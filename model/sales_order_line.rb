class SalesOrderLine < ERPLine
  attr_accessor :sales_price, :qty
  
  def SalesOrderLine.duck
    duck = SalesOrderLine.new SalesOrder.duck, Product.duck
    duck.sales_price = 1.0
    duck.qty = 1
    duck
  end
  
  def initialize so,product
    @part_of = so
    @contains = product
  end
end