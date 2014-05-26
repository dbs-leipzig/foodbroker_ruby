class Ticket < CITTransData
  
  attr_accessor :erp_so_num, :problem, :created_at, :created_by, :allocated_to, :openend_by, :id
  
  @@id = 0
  
  def initialize
    @@id +=1
    @id = @@id
  end
  
  def pk
    :id
  end

end