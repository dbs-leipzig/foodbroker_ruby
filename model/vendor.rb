class Vendor < ERPMasterData
  def initialize kind
    @name = "#{NAMES[:vendor][:adj].sample} #{NAMES[:vendor][:noun].sample} #{NAMES[:cities].sample}"
    super kind
  end
end