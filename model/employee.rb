class Employee < ERPMasterData
  attr_accessor :gender, :position
  
  def initialize kind, position
    @gender = [:male,:female].sample
    @name = "#{NAMES[@gender].sample} #{NAMES[:family].sample}"
    @position = position
    super kind
  end
  
end