class ERPMasterData < MasterData
  attr_reader :kind 
  
  def initialize kind
    @kind = kind
    super()
  end
  
  def pk
    :num
  end
  
  def num
    self.class.to_s[0..2].upcase + self.object_id.to_s
  end
  
  def system
    'ERP'
  end
end