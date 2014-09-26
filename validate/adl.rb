# use -J-Xmx####m

require 'set'

file = File.open ARGV[0]

node_count = 0
edges = []
edge_count = 0

file.each do |line|
  node_count += 1  

  vid = line.to_s.split(',').first.to_i
  line.to_s.split(',').last.split(' ').each do |edge|
    edges.push Set.new([vid,edge.to_i])
    edge_count += 1
  end 
end

puts node_count
puts edge_count
puts edges.uniq.size
