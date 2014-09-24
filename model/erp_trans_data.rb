class ERPTransData < TransData
  
  attr_accessor :date, :num
  
  
  
  def initialize
    @num = @@pk
    super
  end
  
  def pk
    :num
  end
  
  def system
    'ERP'
  end
end
