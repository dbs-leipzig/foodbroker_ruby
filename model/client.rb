class Client < CITMasterData
  attr_accessor :erp_cust_num, :contact_phone, :name, :account
  
  def Client.duck
    Client.new Customer.duck
  end

  @@account = 0
  
  def initialize customer
    @@account +=1
    @account = @@account
    @erp_cust_num = customer
    @name = customer.name
    contact_phone!  
    super()
    
    DomainData.add2stats 1,1      
  end
  
  def pk
    :account
  end
  
  def kind
    erp_cust_num.kind
  end
  
  private
  
  def contact_phone!
    @contact_phone = ""
    @contact_phone += ["0","0","+"].sample
    [10,11,12,13,14].sample.times {@contact_phone += rand(1..9).to_s}  
  end
end