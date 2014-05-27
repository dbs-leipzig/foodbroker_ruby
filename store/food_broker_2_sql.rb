class FoodBroker2Sql
  
  attr_accessor :dump
  private :dump
  
  def initialize
    #@dump = File.new "foodbroker_#{SF}_#{Time.now.strftime "%Y%m%d%H%M"}.sql", 'w'
    @dump = File.new "foodbroker_#{SF}.sql", 'w'
  end
  

  def prepare!  
    (DUCKS.map {|d| d.system }).uniq.each do |system|
      dump.puts "DROP SCHEMA IF EXISTS `#{system}`;"
      dump.puts "CREATE SCHEMA `#{system}`;"
    end
    
    DUCKS.each do |duck|
      
      columns = []
        
      duck.properties.each do |column,value|
        column = "`#{column}`"
        if value.kind_of? Float
          column += "FLOAT"
        elsif value.kind_of? Fixnum
          column += "INT"
        elsif value.kind_of? Date
          column += "DATE"
        else
          column += "VARCHAR(100)"
        end
    
        columns.push column
      end
      
      dump.puts "DROP TABLE IF EXISTS #{duck.system}.#{duck.class};"
      dump.puts "CREATE TABLE #{duck.system}.#{duck.class} (#{columns.join ','});"
    end
  end  
  
  def record objects
    objects.each do |object|
      columns = []
      values = []
  
      object.properties.each do |column,value|
        value = "'#{value}'" unless value.kind_of? Numeric
        columns.push "`#{column}`"
        values.push value          
      end
        dump.puts "INSERT INTO #{object.system}.#{object.class} (#{columns.join ','}) VALUES (#{values.join ','});"
    end
  end
  
  def finish!
    
    DUCKS.each do |duck|
      dump.puts "ALTER TABLE `#{duck.system}`.`#{duck.class}` ADD PRIMARY KEY (`#{duck.pk}`);" if duck.methods.include? :pk
      
      fks = duck.properties(false).select {|k,v| v.kind_of? DomainData }
      fks.select! {|k,v| duck.system == v.system}  
      
      fks.each do |attribute,value|
        dump.puts "ALTER TABLE `#{duck.system}`.`#{duck.class}` ADD FOREIGN KEY (`#{attribute}`) REFERENCES `#{value.system}`.`#{value.class}` (`#{value.pk}`);" 
      end
    end
    
    dump.close
  end
  
  private
  
#  duck.properties.each do |attribute,value|
#    column = "#{attribute} "
      
#    if value.class == Float
#      column += "FLOAT"
#    elsif value.class == Fixnum
#      column += "INT"
#    elsif value.class == Date
#      column += "DATE"
#    else
#      column += "VARCHAR(64)"
#    end

 #   columns.push column
 # end
end