require 'yaml' 

CONF = YAML.load_file 'config.yaml'
SF = ARGV[ARGV.index("-s")+1].to_i
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


# model classes

# boxed_classes = []
# ObjectSpace.each_object(Class) {|c| boxed_classes.push c}  

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

#model_classes = []
#ObjectSpace.each_object(Class) {|c| model_classes.push c} 
#model_classes -= boxed_classes

#model_superclasses = model_classes.map {|c| c.superclass}
#model_superclasses.uniq!  
#model_classes -= model_superclasses

#puts model_classes

DUCKS = []
ObjectSpace.each_object(Class) {|c| DUCKS.push c.duck if c.methods.include? :duck} 
puts DUCKS.reverse


load 'simulation/business_process.rb'
load 'simulation/food_brokerage.rb'
load 'simulation/complaints.rb'

DB.select! {|x| false}
  

  
  