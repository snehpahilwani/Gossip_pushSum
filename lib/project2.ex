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
        nodeMap = %{}
        nodeMap = createNetwork(numNodes, numNodes, topology, algorithm, nodeMap)
        #IO.inspect nodeMap

        # Registering main process as server
        :global.register_name(:server, self())
        :global.sync()

        # Sending rumour to the first node
        #IO.inspect nodeMap[:node1]
        send(:global.whereis_name(:node1),{:rumour})

        # Waiting for rumour received updates from workers
        updateNetworkMap(nodeMap)
        Process.sleep(:infinity)
    end

    def updateNetworkMap(nodeMap) do
        receive do
            {:receivedRumour,k} ->
                IO.puts "Updating status for #{k}th node"
                node_string = Enum.join(["node",k])
                node_atom = String.to_atom(node_string) 
                nodeMap = %{nodeMap | "#{node_atom}": 1}
        end
        IO.inspect nodeMap

        # See if the network has converged, i.e. all nodes have received rumor

        #Keep looking out for more updates from workers
        updateNetworkMap(nodeMap)
    end


    def createNetwork(max, numNodes, topology, algorithm, nodeMap) do
        if max<1 do
            IO.puts "Finished creating the network"
            nodeMap
        else
            IO.puts "Num : #{max}"

            node_pid = spawn(Worker, :talktoworkers, [max, numNodes, topology, algorithm])

            node_string = Enum.join(["node",max])
            node_atom = String.to_atom(node_string)
            IO.puts node_atom
            :global.register_name(node_atom, node_pid)
            :global.sync()
            nodeMap = Dict.put_new(nodeMap, node_atom, 0)
            

            createNetwork(max-1, numNodes, topology, algorithm, nodeMap)
        end
    end 
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