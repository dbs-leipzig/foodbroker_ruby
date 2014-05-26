class MasterData < DomainData
  def initialize
    DB.push self
  end
  
  attr_reader :name
end