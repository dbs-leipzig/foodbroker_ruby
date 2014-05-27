class Customer < ERPMasterData
  
  def Customer.duck
    Customer.new :kind
  end
  
  
  def initialize kind
    @name = "#{NAMES[:customer][:adj].sample} #{NAMES[:customer][:noun].sample} #{NAMES[:cities].sample}"
    super kind
    
    DomainData.add2stats 1,0
  end
  
end