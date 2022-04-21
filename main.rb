require 'faraday'

def get_node(nodes_seen, node_ids)
  next_ids = []
  res = Faraday.get("https://nodes-on-nodes-challenge.herokuapp.com/nodes/#{node_ids}")
  
  JSON.parse(res.body).each do |node|
    nodes_seen[node["id"]] += 1
    next_ids += node["child_node_ids"]
  end

  get_node(nodes_seen, next_ids.join(',')) unless next_ids.empty?
end

nodes_seen = Hash.new(0)

get_node(nodes_seen, '089ef556-dfff-4ff2-9733-654645be56fe')

puts "# Question 1 question: What is the total number of unique nodes?"
puts "Answer: #{nodes_seen.keys.count}"

max_node = nodes_seen.max_by{|k,v| v}
puts "# Question 2 question: Which node ID is shared the most among all other nodes?"
puts "Answer: #{max_node[0]} was seen #{max_node[1]} times."

