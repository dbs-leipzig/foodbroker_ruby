class Product < ERPMasterData
  attr_accessor :group, :price
  
  def Product.duck
    Product.new :kind
  end
  
  def initialize kind
    @group = [:fruits,:fruits,:vegetables,:vegetables,:nuts].sample
    @name = "#{NAMES[@group].sample}, #{NAMES[:product][:adj].sample} #{NAMES[:product][:adj].sample}"
    price!
    super kind
  end
  
  private
  
  def price!
    conf = CONF['MasterData']['Product']['price']
    min = conf['min']
    max = conf['max']
    @price = (rand min..max).round 2
  end
end