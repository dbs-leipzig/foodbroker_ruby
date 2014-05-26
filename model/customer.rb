class Customer < ERPMasterData
  def initialize kind
    @name = "#{NAMES[:customer][:adj].sample} #{NAMES[:customer][:noun].sample} #{NAMES[:cities].sample}"
    super kind
  end
  
end