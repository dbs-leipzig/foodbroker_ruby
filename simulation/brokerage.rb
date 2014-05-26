conf = CONF['FoodBrokerage']
dates = (conf['Process']['date']['min']..conf['Process']['date']['max']).to_a
cases = (1..conf['Process']['growth']*SF)

# cases  
    
cases.each do |c|
  tdos = []
    
  # quotation
    
  quot = Quotation.new
  quot.status = :open
  quot.date =  dates[c*dates.size/cases.size]
  quot.date = dates.last if quot.date.nil?
  quot.sent_by = (DB.select {|e| (e.instance_of? Employee) && (e.position == :sales_representative)}).sample
  quot.sent_to = (DB.select {|c| c.instance_of? Customer}).sample
  tdos.push quot
  
  # quotation lines
  
  qls = []
  margin = Transition.variation conf['Quotation']['margin'], [quot.sent_by,quot.sent_to]
     
  prod_cnt = Transition.random conf['Quotation']['lines']
  products = (DB.select {|c| c.instance_of? Product}).shuffle[0,prod_cnt]
    
  products.each do |product|
    ql = QuotationLine.new quot,product
    ql.purch_price = product.price
    ql.sales_price = (ql.purch_price * (1+margin)).round 2 
    ql.qty = Transition.random conf['Quotation']['quantity']
    
    qls.push ql
  end  
  
  tdos += qls
  
  # confirmation
  
  if Transition.happens? conf['Quotation']['confirmation']['prob'], [quot.sent_by,quot.sent_to]
    
    # sales order

    so = SalesOrder.new 
    #so.status = :backorder
    so.based_on = quot
    so.processed_by = (DB.select {|e| (e.instance_of? Employee) && (e.position == :sales_editor)}).sample
    so.received_from = quot.sent_to  
    so.date = quot.date + Transition.delay(conf['Quotation']['confirmation']['delay'],[ quot.sent_by,quot.sent_to])
    so.delivery_date = so.date + Transition.delay(conf['SalesOrder']['days2delivery'],[ so.processed_by,so.received_from])
    
    if so.date <= dates.last 
      quot.status = :confirmed   
      tdos.push(so)
      
      dns = []
      
      # sales order lines 
      
      sols = []
      
      qls.each do |ql|
        if (Transition.happens? conf['Quotation']['confirmation']['line_prob'],[]) || sols.empty? && ql == qls.last
          sol = SalesOrderLine.new so, ql.contains
          sol.qty = ql.qty
          sol.sales_price = ql.sales_price
          sols.push sol
        end
      end    
      
      tdos += sols
      
      # sales invoice
      
      si = SalesInvoice.new
      si.date = so.date + Transition.delay(conf['SalesOrder']['days2invoice'],[so.processed_by])
      si.text = "Invoice SO#{so.num}"
      
      si.revenue = 0
      sols.each {|s| si.revenue += s.qty * s.sales_price}
      si.revenue = si.revenue.round 2
      
      tdos.push si if si.date <= dates.last  
      
      # purchase orders
      
      pos = {}
      (sols.map {|s| s.contains.group}).uniq.each {|g| pos.store g,PurchOrder.new}  
        
      dns = []   
        
      pos.each do |prod_group,po|
        po.processed_by = (DB.select {|e| (e.instance_of? Employee) && (e.position == :purchaser)}).sample
        po.date = so.date + Transition.delay(conf['SalesOrder']['days2purchase'],[po.processed_by])
        po.serves = so
        po.placed_at = (DB.select {|v| v.instance_of? Vendor}).sample
        #po.status = :sent
        
        
        if po.date <= dates.last  
          tdos.push po 
          pols = []
          
          # purchase order lines
            
          (sols.select {|s| s.contains.group == prod_group}).each do |sol|
 
            pol = PurchOrderLine.new po, sol.contains
            pol.qty = sol.qty
            
            var = Transition.variation conf['PurchOrder']['price_variation'], [po.placed_at,po.processed_by]
            pol.purch_price = (pol.contains.price * (1+var)).round 2
            
            pols.push pol  
          end
          
          tdos += pols
          
          # purchase invoices
          
          pi = PurchInvoice.new
          pi.date = so.date + Transition.delay(conf['PurchOrder']['days2invoice'],[po.placed_at])
          pi.text = "Invoice PO#{po.num}"
          
          pi.expense = 0
          pols.each {|p| pi.expense += p.qty * p.purch_price}
          pi.expense = pi.expense.round 2
          
          tdos.push pi if pi.date <= dates.last 
          
          # delivery notes
          
          dn = DeliveryNote.new
          dn.contains = po
          dn.date = po.date + Transition.delay(conf['PurchOrder']['days2delivery'],[ po.placed_at, po.processed_by])
          dn.operated_by = (DB.select {|v| v.instance_of? Logistics}).sample
          dn.tracking_code = dn.operated_by.rand_tracking_code
          
          dns.push dn
          tdos.push dn if dn.date <= dates.last  
        end
        

        
        # late delivery complaint
      
        late_dns = (dns.select {|d| d.date > so.delivery_date})
          
        unless late_dns.empty?  
          
          # ticket
          
          tic = Ticket.new
          tic.erp_so_num = so
          tic.created_at = so.delivery_date
          tic.problem = :late_delivery
          tic.created_by = (DB.select {|e| e.instance_of? User }).sample
          tic.allocated_to = (DB.select {|e| e.instance_of? User }).sample    
          tic.openend_by = so.received_from # TODO Customer
          
          tdos.push tic
          
          # sales refund
          
          late_sols = []
          # HERE
          
          refund = Transition.variation conf['Ticket']['sales_refund'], [tic.allocated_to,tic.openend_by]
          
          si = SalesInvoice.new
          si.date = so.delivery_date
          si.text = "Refund SO#{so.num} Ticket #{tic.id}"
          
          si.revenue = 0
          late_sols.each {|s| si.revenue -= s.qty * s.sales_price}
          si.revenue = (si.revenue * refund).round 2
          
          tdos.push si
          
          # purchase refund
          
          late_dns.each do |dns|
            if (dns.date - po.date) > (po.date - so.date)
              refund = Transition.variation conf['Ticket']['sales_refund'], [tic.allocated_to,po.placed_at]
                
              pi = PurchInvoice.new
              pi.date =so.delivery_date
              pi.text = "Refund PO#{po.num} Ticket #{tic.id}"
              
              pi.expense = 0
              pols.each {|p| pi.expense -= p.qty * p.purch_price}
              pi.expense = (pi.expense * refund).round 2
              
              tdos.push pi
            end  
          end  
        end
        
        # bad quality complaint
        
        (tdos.select{|d| d.instance_of? DeliveryNote}).each do |dn|
          products = (tdos.select {|p| (p.instance_of? PurchOrderLine) && p.part_of == dn.contains}).map {|p| p.contains}
          if Transition.happens? conf['Ticket']['bad_quality'],products + [dn.operated_by,dn.contains.placed_at]
            tic = Ticket.new
            tic.erp_so_num = so
            tic.created_at = dn.date
            tic.problem = :bad_quality
            tic.created_by = (DB.select {|e| e.instance_of? User }).sample
            tic.allocated_to = (DB.select {|e| e.instance_of? User }).sample    
            tic.openend_by = so.received_from # TODO Customer
            
            tdos.push tic
          end          
        end
      end   
    end
  else
    quot.status = :lost    
  end
  
  puts "-"*50 + "#{c}/#{conf['Process']['growth']*SF}" + "-"*50
  puts tdos
end