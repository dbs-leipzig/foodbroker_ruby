class MasterData < DomainData
  def initialize
    DB.push self
    super
  end
  
  attr_reader :name
end
