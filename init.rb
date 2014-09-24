require 'yaml' 

CONF = YAML.load_file 'config.yaml'
SF = ARGV[ARGV.index("-s")+1].to_i
FORMAT = ARGV[ARGV.index("-f")+1].to_sym
DB = []

NAMES = {}  
  
Dir.entries("names").each do |entry|
  unless entry.include? '.'
    keys = entry.split '_'
    sym = keys.first.to_sym
       
    if keys.length == 1 
      NAMES.store sym, [] unless NAMES.has_key? sym
      ref = NAMES[sym]
    else
      NAMES.store sym, {} unless NAMES.has_key? sym
      sub = keys.last.to_sym
      NAMES[sym].store sub,[]
      ref = NAMES[sym][sub]
    end
    
    file = File.new("names/#{entry}")
    file.each{|l| ref.push l.delete("\n")}
  end
end

load 'model/domain_data.rb'
load 'model/master_data.rb'
load 'model/trans_data.rb'
load 'model/erp_master_data.rb'
load 'model/cit_master_data.rb'
load 'model/erp_trans_data.rb'
load 'model/cit_trans_data.rb'
load 'model/erp_line.rb'
load 'model/employee.rb'
load 'model/product.rb'
load 'model/customer.rb'
load 'model/vendor.rb'
load 'model/logistics.rb'
load 'model/quotation.rb'
load 'model/quotation_line.rb'
load 'model/sales_order.rb'
load 'model/sales_order_line.rb'
load 'model/sales_invoice.rb'
load 'model/purch_order.rb'
load 'model/purch_order_line.rb'
load 'model/delivery_note.rb'
load 'model/purch_invoice.rb'
load 'model/user.rb'
load 'model/client.rb'
load 'model/ticket.rb'

DUCKS = []
ObjectSpace.each_object(Class) {|c| DUCKS.push c.duck if c.methods.include? :duck} 
DUCKS.reverse!

DB.select! {|x| false}

load 'simulation/business_process.rb'
load 'simulation/food_brokerage.rb'
load 'simulation/complaints.rb'
load 'store/food_broker_2_sql.rb'
load 'store/food_broker_2_adjacency_list.rb'

  

  
  
