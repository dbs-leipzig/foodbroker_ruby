class PurchOrderLine < ERPLine
  attr_accessor :purch_price, :qty
  
  def PurchOrderLine.duck 
    duck = PurchOrderLine.new PurchOrder.duck, Product.duck
    duck.purch_price = 1.0
    duck.qty = 1
    duck
  end
  
  def initialize po,product
    @part_of = po
    @contains = product
    
    DomainData.add2stats 0,1    
  end
end