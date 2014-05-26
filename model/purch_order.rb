class PurchOrder < ERPTransData
  attr_accessor :serves, :processed_by, :placed_at#, :status
  
  def PurchOrder.duck 
    duck = PurchOrder.new
    duck.serves = SalesOrder.duck
    duck.placed_at = Vendor.duck
    duck.date = Date.new
    duck
  end
  
  def sales2purch
    date - serves.date
  end
end