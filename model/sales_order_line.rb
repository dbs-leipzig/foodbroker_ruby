class SalesOrderLine < ERPLine
  attr_accessor :sales_price, :qty
  
  def initialize so,product
    @part_of = so
    @contains = product
  end
end