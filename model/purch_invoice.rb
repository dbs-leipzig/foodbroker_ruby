class PurchInvoice < ERPTransData
  attr_accessor :expense, :text, :created_for
  
  def PurchInvoice.duck
    duck = PurchInvoice.new 
    duck.expense = 1.0
    duck.text = ""
    duck.created_for = PurchOrder.duck
    duck.date = Date.new
    duck
  end
end