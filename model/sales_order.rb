class SalesOrder < ERPTransData
  attr_accessor :based_on, :processed_by, :delivery_date, :received_from#, :status
  
  def SalesOrder.duck
    duck = SalesOrder.new
    duck.based_on = Quotation.duck
    duck.processed_by = Employee.duck
    duck.delivery_date = Date.new
    duck.received_from = Customer.duck
    duck.date = Date.new
    duck
  end

  def initialize
    super()
  end
end