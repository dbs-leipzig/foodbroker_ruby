# employees and users

conf = CONF['MasterData']['Employee']

[:sales_representative,:sales_editor,:purchaser].each do |position|
  number = (conf['offset']+conf['growth'])*SF/3
  good = (number * conf['good']).to_i
  bad = (number * conf['bad']).to_i
  normal = number.to_i - good - bad  
    
  good.times { Employee.new :good, position }
  bad.times { Employee.new :bad, position }
  normal.times { Employee.new :normal, position }  
end

(DB.select {|o| o.instance_of? Employee}).each {|e| User.new e}

# products

conf = CONF['MasterData']['Product']

number = (conf['offset']+conf['growth'])*SF  
good = (number * conf['good']).to_i
bad = (number * conf['bad']).to_i
normal = number.to_i - good - bad

good.times { Product.new :good }
bad.times { Product.new :bad }
normal.times { Product.new :normal }  
  
# customers
  
conf = CONF['MasterData']['Customer']

number = (conf['offset']+conf['growth'])*SF  
good = (number * conf['good']).to_i
bad = (number * conf['bad']).to_i
normal = number.to_i - good - bad

good.times { Customer.new :good }
bad.times { Customer.new :bad }
normal.times { Customer.new :normal }  
  
# vendors

conf = CONF['MasterData']['Vendor']

number = (conf['offset']+conf['growth'])*SF  
good = (number * conf['good']).to_i
bad = (number * conf['bad']).to_i
normal = number.to_i - good - bad

good.times { Vendor.new :good }
bad.times { Vendor.new :bad }
normal.times { Vendor.new :normal }  
  
# logistics

conf = CONF['MasterData']['Logistics']

number = (conf['offset']+conf['growth'])*SF  
good = (number * conf['good']).to_i
bad = (number * conf['bad']).to_i
normal = number.to_i - good - bad

good.times { Logistics.new :good }
bad.times { Logistics.new :bad }
normal.times { Logistics.new :normal }  