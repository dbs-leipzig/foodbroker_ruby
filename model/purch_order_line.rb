class PurchOrderLine < ERPLine
  attr_accessor :purch_price, :qty
  
  def initialize po,product
    @part_of = po
    @contains = product
  end
end