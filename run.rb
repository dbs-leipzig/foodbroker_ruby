load 'init.rb'
load 'simulation/master_data.rb'
#load 'simulation/brokerage.rb'

#(DB.select {|l| l.instance_of? Logistics}).each {|l| puts l.rand_tracking_code}

#puts DB

conf = CONF['FoodBrokerage']
dates = (conf['Process']['date']['min']..conf['Process']['date']['max']).to_a
cases = (1..conf['Process']['growth']*SF)
  
cases.each do |i| 
  puts "-"*50 + "#{i}/#{conf['Process']['growth']*SF}" + "-"*50
  fb = FoodBrokerage.new dates[i*dates.size/cases.size]
  #puts fb.tdos
  cp = Complaints.new fb
  #puts cp.tdos
end

