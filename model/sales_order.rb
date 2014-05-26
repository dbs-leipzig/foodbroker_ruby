class SalesOrder < ERPTransData
  attr_accessor :based_on, :processed_by, :delivery_date, :received_from, :status

  def initialize
    super()
  end
end