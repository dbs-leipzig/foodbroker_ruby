class Complaints < BusinessProcess
  attr_accessor :conf, 
                :tdos, 
                :tickets,
                :cas,
                :late_delivery_notes,
                :bad_delivery_notes
  private :conf
  
  def initialize cas
    @cas = cas
    @conf = CONF['Complaints']
    @tdos = []
    @tickets = []
    if (cas.instance_of? FoodBrokerage) && !cas.sales_order.nil?
      late_deliveries!
      bad_quality!
    end
  end
  
  private
  
  def new_ticket
    ticket = Ticket.new 
    ticket.erp_so_num = cas.sales_order
    ticket.created_by = (DB.select {|e| e.instance_of? User }).sample
    ticket.allocated_to = (DB.select {|e| e.instance_of? User }).sample    
    ticket.openend_by = cas.sales_order.received_from # TODO Customer
    tickets.push ticket
    tdos.push ticket
    ticket
  end  
  
  def late_deliveries!
    @late_delivery_notes = cas.delivery_notes.select {|dn| dn.date > cas.sales_order.delivery_date}
      
    unless late_delivery_notes.empty?
      ticket = new_ticket
      ticket.created_at = cas.sales_order.delivery_date
      ticket.problem = :late_delivery
      
      affected_purch_orders = late_delivery_notes.map {|dn| dn.contains}
      affected_purch_order_lines = cas.purch_order_lines.select {|pol| affected_purch_orders.include? pol.part_of}
      affected_products =  affected_purch_order_lines.map {|pol| pol.contains} 
      affected_sales_order_lines = cas.sales_order_lines.select {|sol| affected_products.include? sol.contains}
      
      sales_refund! ticket, affected_sales_order_lines
      
      late_delivery_notes.each do |delivery_note|
        if delivery_note.purch2delivery >= delivery_note.contains.sales2purch
          purch_refund! ticket, delivery_note
        end
      end
      
    end    
  end
  
  def bad_quality!
    @bad_delivery_notes = []
      
    cas.delivery_notes.each do |delivery_note|
      products = (cas.purch_order_lines.select {|pol| pol.part_of == delivery_note.contains}).map {|pol| pol.contains}
        
      if happens? conf['Ticket']['bad_quality'], products + [delivery_note.operated_by,delivery_note.contains.placed_at]
        ticket = new_ticket
        ticket.created_at = delivery_note.date
        ticket.problem = :bad_quality
        

        affected_purch_order_lines = cas.purch_order_lines.select {|pol| delivery_note.contains = pol.part_of}
        affected_products =  affected_purch_order_lines.map {|pol| pol.contains} 
        affected_sales_order_lines = cas.sales_order_lines.select {|sol| affected_products.include? sol.contains}
        
        sales_refund! ticket, affected_sales_order_lines
        purch_refund! ticket, delivery_note
      end      
    end 
  end
  
  def sales_refund! ticket, sales_order_lines
    refund = variation conf['Ticket']['sales_refund'], [ticket.allocated_to,ticket.openend_by]          
    sales_invoice = SalesInvoice.new
    sales_invoice.date = ticket.created_at
    sales_invoice.text = "Refund SO#{cas.sales_order.num} Ticket #{ticket.id}"
    sales_invoice.created_for = cas.sales_order
    
    sales_invoice.revenue = 0
    sales_order_lines.each {|sol| sales_invoice.revenue -= sol.qty * sol.sales_price}
    sales_invoice.revenue = (sales_invoice.revenue * refund).round 2
    
    tdos.push sales_invoice
  end
  
  def purch_refund! ticket, delivery_note
    refund = variation conf['Ticket']['purch_refund'], [ticket.allocated_to,delivery_note.contains.placed_at]          
    purch_invoice = PurchInvoice.new
    purch_invoice.date = ticket.created_at
    purch_invoice.text = "Refund PO#{delivery_note.contains.num} Ticket #{ticket.id}"
    
    purch_invoice.expense = (cas.purch_invoices.select {|pi| pi.created_for = delivery_note.contains}).first.expense
    purch_invoice.expense = (purch_invoice.expense  * -1 * refund).round 2
    
    tdos.push purch_invoice
  end
end