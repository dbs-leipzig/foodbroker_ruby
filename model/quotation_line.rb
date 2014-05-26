class QuotationLine < ERPLine
  attr_accessor :sales_price, :purch_price, :qty
  
  def initialize quot,product
    @part_of = quot
    @contains = product
  end
end