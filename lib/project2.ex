defmodule Project2 do
  def main(args) do
    
    if Enum.count(args) == 3 do
        {numNodes,_} = Integer.parse(Enum.at(args,0))
        topology = Enum.at(args,1)
        
        algorithm = Enum.at(args,2)
       
    else
        IO.puts "Invalid number of arguments. Please provide ./project2 numNodes topology algorithm"
        System.halt(0)
    end
    
    createNetwork(numNodes, numNodes, topology, algorithm)
    Process.sleep(:infinity)
  end


  def createNetwork(max, numNodes, topology, algorithm) do
    if max<1 do
        IO.puts "Finished creating the network"
    else
        IO.puts "Num : #{max}"

        node_pid = spawn(Worker, :talktoworkers, [max, numNodes, topology, algorithm])

        IO.inspect node_pid

        node_string = Enum.join(["node",:max])
        node_atom = String.to_atom(node_string)
        :global.register_name(node_atom, node_pid)
        :global.sync()


        createNetwork(max-1, numNodes, topology, algorithm)
    end
  end 

    # def setFullTopology(numNodes) do
        
    # end
end




# cond do
#     algorithm == "gossip" ->
#         #gossip(framedTopology)
#         IO.puts "gossip"
#     algorithm == "push-sum" ->
#         #pushSum(framedTopology)
#         System.halt(0)
#     true ->
#         IO.puts "invalid algo option"
#         System.halt(0)
# end