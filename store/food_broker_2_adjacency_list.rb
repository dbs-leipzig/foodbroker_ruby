class FoodBroker2AdjacencyList
  
  attr_accessor :dump
  private :dump
  
  def initialize
    #@dump = File.new "foodbroker_#{SF}_#{Time.now.strftime "%Y%m%d%H%M"}.sql", 'w'
    @dump = File.new "foodbroker_#{SF}.adl", 'w'
  end
  
  def prepare!  
  end  
  
  def record objects
    objects.each do |object|
      if object.class.to_s.include? 'Line'
        domain_objects = []
        object.properties(false).each {|c,v|domain_objects.push v if v.kind_of? DomainData}
        domain_objects.first.vids.push domain_objects.last.vid        
        domain_objects.last.vids.push domain_objects.first.vid 
      else
        object.properties(false).each do |column,value|
          if value.kind_of? DomainData
            object.vids.push value.vid
            value.vids.push object.vid
          end
        end

        dump.puts "#{object.vid},#{(object.kind_of? MasterData) ? 1 : 0},#{object.vids.uniq.join ' '}"
      end
    end
  end
  
  def finish!
    dump.close
  end
  
  private
  
end
