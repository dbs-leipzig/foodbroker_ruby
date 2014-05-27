class QuotationLine < ERPLine
  attr_accessor :sales_price, :purch_price, :qty
  
  def QuotationLine.duck
    duck = QuotationLine.new Quotation.duck, Product.duck
    duck.sales_price = 1.0
    duck.purch_price = 1.0
    duck.qty = 1
    duck
  end
  
  def initialize quot,product
    @part_of = quot
    @contains = product
    
    DomainData.add2stats 0,1    
  end
end