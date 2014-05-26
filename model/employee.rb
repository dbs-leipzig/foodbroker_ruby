class Employee < ERPMasterData
  attr_accessor :gender, :position
  
  def Employee.duck 
    duck = Employee.new :kind, ""
  end
  
  def initialize kind, position
    @gender = [:male,:female].sample
    @name = "#{NAMES[@gender].sample} #{NAMES[:family].sample}"
    @position = position
    super kind
  end

end