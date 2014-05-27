class ERPLine < DomainData
  attr_accessor :part_of, :contains
  
  def system
    'ERP'
  end
end