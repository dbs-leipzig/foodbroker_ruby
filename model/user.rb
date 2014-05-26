class User < CITMasterData
  attr_reader :email, :erp_empl_num
  
  def initialize employee
    @name = employee.name
    @email = employee.name.sub(' ','.').downcase + '@foodbroker.org'
    @erp_empl_num = employee
    super()
  end

  def kind
    @erp_empl_num.kind
  end
    
  def pk
    :email
  end
end