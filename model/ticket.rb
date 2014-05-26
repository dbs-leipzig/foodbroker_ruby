class Ticket < CITTransData
  
  attr_accessor :erp_so_num, :problem, :created_at, :created_by, :allocated_to, :opened_by, :id
  
  def Ticket.duck
    duck = Ticket.new 
    duck.erp_so_num = SalesOrder.duck
    duck.created_at = Date.new
    duck.created_by = User.duck
    duck.allocated_to = User.duck
    duck.opened_by = Client.duck
    duck
  end
  
  @@id = 0
  
  def initialize
    @@id +=1
    @id = @@id
  end
  
  def pk
    :id
  end

end