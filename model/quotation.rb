class Quotation < ERPTransData
  attr_accessor :sent_by, :sent_to, :status
  
  def Quotation.duck
    duck = Quotation.new
    duck.sent_by = Employee.duck
    duck.sent_to = Customer.duck
    duck.status = :status
    duck.date = Date.new
    duck
  end
  
  def initialize
    super()
    
    DomainData.add2stats 1,2    
  end
end