class Logistics < ERPMasterData
  
  def Logistics.duck
    Logistics.new :kind
  end
  
  def initialize kind
    @name = "#{NAMES[:logistics][:adj].sample} #{NAMES[:logistics][:noun].sample}"
    super kind
    @code_prefix = (@name.split(' ').first[0..1]+@name.split(' ').last[0]).upcase + ['/','#','-','_'].sample
    @code_length = rand(10..20)
    @code_has_chars = [true,false].sample
    
    DomainData.add2stats 1,0    
  end
  
  def rand_tracking_code
    code = @code_prefix 
    @code_length.times {code += chars.sample.to_s }
    code
  end
  
  private
  
  def chars
    if @code_has_chars 
      (0..9).to_a + ('A'..'Z').to_a  
    else
      (0..9).to_a
    end
  end
end