class FoodBrokerage < BusinessProcess
  attr_accessor :conf, 
                :tdos, 
                :quotation,     :quotation_lines, 
                :sales_order,   :sales_order_lines, 
                :sales_invoice, 
                :purch_orders,  :purch_order_lines, 
                :delivery_notes, 
                :purch_invoices
  
  def initialize start_date
    @conf = CONF['FoodBrokerage']
    @max_date = conf['Process']['date']['max']
    @start_date = start_date
    @start_date = @max_date if start_date.nil?

    @tdos = []
    
    quotation!
    if sales_order!
      sales_invoice!
      purch_orders!
      delivery_notes!
      purch_invoices!  
    end   
  end
  
  private
  
  def quotation!
    @quotation = Quotation.new
    quotation.status = :open
    quotation.date = @start_date
    quotation.sent_by = (DB.select {|e| e.instance_of? Employee}).sample
    quotation.sent_to = (DB.select {|c| c.instance_of? Customer}).sample
    tdos.push quotation
    
    @quotation_lines = []
    margin = variation conf['Quotation']['margin'], [quotation.sent_by,quotation.sent_to]
    prod_cnt = random conf['Quotation']['lines']
    products = (DB.select {|c| c.instance_of? Product}).shuffle[0,prod_cnt]
      
    products.each do |product|
      quotation_line = QuotationLine.new quotation,product
      quotation_line.purch_price = product.price
      quotation_line.sales_price = (quotation_line.purch_price * (1+margin)).round 2 
      quotation_line.qty = random conf['Quotation']['quantity']
      quotation_lines.push quotation_line
      tdos.push quotation_line
    end  
  end
  
  def sales_order!
    if happens? conf['SalesOrder']['conf_prob'], [quotation.sent_by,quotation.sent_to]
      quotation.status = :confirmed
      @sales_order = SalesOrder.new 
      sales_order.based_on = quotation
      sales_order.processed_by = (DB.select {|e| e.instance_of? Employee}).sample
      sales_order.received_from = quotation.sent_to  
      sales_order.date = quotation.date + delay(conf['SalesOrder']['days2conf'],[ quotation.sent_by,quotation.sent_to])
      sales_order.delivery_date = sales_order.date + delay(conf['SalesOrder']['days2delivery'],[ sales_order.processed_by,sales_order.received_from])
      tdos.push sales_order 
      
      @sales_order_lines = [] 
      quotation_lines.each do |quotation_line|
        if (happens? conf['SalesOrder']['line_prob'],[]) || sales_order_lines.empty? && quotation_line == quotation_lines.last
          sales_order_line = SalesOrderLine.new sales_order, quotation_line.contains
          sales_order_line.qty = quotation_line.qty
          sales_order_line.sales_price = quotation_line.sales_price
          sales_order_lines.push sales_order_line
        end
      end    
      
      self.tdos += sales_order_lines
    else
      quotation.status = :lost
      false
    end 
  end
  
  def sales_invoice!
    @sales_invoice = SalesInvoice.new
    sales_invoice.date = sales_order.date + delay(conf['SalesOrder']['days2invoice'],[sales_order.processed_by])
    sales_invoice.text = "Invoice SO#{sales_order.num}"
    sales_invoice.revenue = 0
    sales_invoice.created_for = sales_order
    sales_order_lines.each {|sol| sales_invoice.revenue += sol.qty * sol.sales_price}
    sales_invoice.revenue = sales_invoice.revenue.round 2
    tdos.push sales_invoice 
  end
  
  def purch_orders!
    @purch_orders = []
    @purch_order_lines = []
      
    product_groups = sales_order_lines.map {|sol| sol.contains.group}   
      
    product_groups.uniq.each do |product_group|
      purch_order = PurchOrder.new
      purch_order.processed_by = (DB.select {|e| e.instance_of? Employee}).sample
      purch_order.date = sales_order.date + delay(conf['SalesOrder']['days2purchase'],[purch_order.processed_by])
      purch_order.serves = sales_order
      purch_order.placed_at = (DB.select {|v| v.instance_of? Vendor}).sample
      purch_orders.push purch_order

      (sales_order_lines.select {|sol| sol.contains.group == product_group}).each do |sales_order_line|
         purch_order_line  = PurchOrderLine.new purch_order, sales_order_line.contains
         purch_order_line.qty = sales_order_line.qty
         
         var = variation conf['PurchOrder']['price_variation'], [purch_order.placed_at,purch_order.processed_by]
         purch_order_line.purch_price = (purch_order_line.contains.price * (1+var)).round 2
         
         purch_order_lines.push purch_order_line
       end
    end  
       
    self.tdos += purch_orders
    self.tdos += purch_order_lines
  end
  
  def delivery_notes!
    @delivery_notes = []
    
    purch_orders.each do |purch_order|
      delivery_note = DeliveryNote.new
      delivery_note.contains = purch_order
      delivery_note.date = purch_order.date + delay(conf['PurchOrder']['days2delivery'],[ purch_order.placed_at, purch_order.processed_by])
      delivery_note.operated_by = (DB.select {|v| v.instance_of? Logistics}).sample
      delivery_note.tracking_code = delivery_note.operated_by.rand_tracking_code
      delivery_notes.push delivery_note
    end  
 
    self.tdos += delivery_notes
  end
  
  def purch_invoices!  
    @purch_invoices = []
    
    purch_orders.each do |purch_order|
      purch_invoice = PurchInvoice.new
      purch_invoice.date = purch_order.date + delay(conf['PurchOrder']['days2invoice'],[purch_order.placed_at])
      purch_invoice.text = "Invoice PO#{purch_order.num}"
      purch_invoice.expense = 0
      purch_invoice.created_for = purch_order
      purch_order_lines_of_order = purch_order_lines.select {|pol| pol.part_of == purch_order}
      purch_order_lines_of_order.each {|pol| purch_invoice.expense += pol.qty * pol.purch_price}
      purch_invoice.expense = purch_invoice.expense.round 2
      purch_invoices.push purch_invoice
    end
    
    self.tdos += purch_invoices
  end
    
end
