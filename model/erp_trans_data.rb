class ERPTransData < TransData
  
  attr_accessor :date, :num
  
  @@pk = 0
  
  def initialize
    @@pk +=1
    @num = @@pk
  end
  
  def pk
    :num
  end
  
  def system
    'ERP'
  end
end