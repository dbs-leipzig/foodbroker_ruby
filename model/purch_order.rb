class PurchOrder < ERPTransData
  attr_accessor :serves, :processed_by, :placed_at, :status
  
  def sales2purch
    date - serves.date
  end
end