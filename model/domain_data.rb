class DomainData

  attr_reader :vid, :vids
  
  @@objects = 0
  @@relationships = 0
  @@pk = 0

  def initialize
    @@pk +=1
    @vid = @@pk
    @vids = []
  end  

  def properties id_only=true
    attributes = instance_variables.sort.select.to_a
    attributes.map! {|a| a.to_s.delete '@'}
    attributes.insert 0, self.pk.to_s if self.public_methods.include? :pk
    attributes.select! {|a| a != 'kind' && (self.public_methods.include? a.to_sym)}
      
    properties = {}  
    
    attributes.each do |attribute|
      value = self.send attribute
      value = value.send value.pk if (value.kind_of? DomainData) && id_only
      properties.store attribute, value#.to_s 
    end

    properties
  end
  
  def to_s
    "#{self.class} #{properties.to_s}"
  end
  
  def DomainData.stats
    "#{@@objects} / #{@@relationships}"
  end
  
  def DomainData.add2stats(o,r)
    @@objects+=o
    @@relationships+=r
  end
end
