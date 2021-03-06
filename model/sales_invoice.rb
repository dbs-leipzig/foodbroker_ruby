class SalesInvoice < ERPTransData
  attr_accessor :revenue, :text, :created_for
  
  def SalesInvoice.duck
    duck = SalesInvoice.new 
    duck.revenue = 1.0
    duck.text = ""
    duck.created_for = SalesOrder.duck
    duck.date = Date.new
    duck
  end
  
  def initialize
    super()
    
    DomainData.add2stats 1,1    
  end
end