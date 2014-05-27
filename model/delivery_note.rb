class DeliveryNote < ERPTransData
  attr_accessor :contains, :operated_by, :tracking_code
  
  def DeliveryNote.duck
    duck = DeliveryNote.new
    duck.contains = PurchOrder.duck
    duck.operated_by = Logistics.duck
    duck.tracking_code = Logistics.duck.rand_tracking_code
    duck.date = Date.new
    duck
  end
  
  def initialize
    super()
    
    DomainData.add2stats 1,2    
  end
  
  def purch2delivery
    date - contains.date
  end

end
