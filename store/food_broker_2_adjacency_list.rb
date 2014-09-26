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
    lines = objects.select {|o| o.class.to_s.include? 'Line'}
    objects -= lines

    lines.each do |line|
      domain_objects = []
      line.properties(false).each {|c,v|domain_objects.push v if v.kind_of? DomainData}
      domain_objects.first.vids.push domain_objects.last.vid        
      domain_objects.last.vids.push domain_objects.first.vid 
    end

    objects.each do |object|
      object.properties(false).each do |column,value|
        if value.kind_of? DomainData
          object.vids.push value.vid
          value.vids.push object.vid
        end
      end
    end

    objects.each {|o| dump.puts "#{o.vid},#{(o.kind_of? MasterData) ? 1 : 0},#{o.vids.uniq.join ' '}"}
  end
  
  def finish!
    dump.close
  end
  
  private
  
end
