class DeliveryNote < ERPTransData
  attr_accessor :contains, :operated_by, :tracking_code
  
  def purch2delivery
    date - contains.date
  end

end
