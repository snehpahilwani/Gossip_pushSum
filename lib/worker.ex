defmodule Worker do

  def talktoworkers(k, numNodes, topology, algorithm) do
    IO.puts "wrkr"


    cond do
        topology == "full" ->
            #setFullTopology(numNodes)
            IO.puts "full"
        topology == "2D" ->
            #set2DTopology(numNodes)
            IO.puts "2d"
        topology == "line" ->
            
            IO.puts "line"
            IO.puts "My neighbors are:"
            # myPid = Integer.parse(k)
            IO.puts k
            neighbor1 = k - 1
            neighbor2 = k + 1
            IO.puts neighbor1
            IO.puts neighbor2
            if k > 1 && k < numNodes do
                #These are the non extreme nodes
                IO.puts "These are the non extreme nodes"
                # IO.inspect :global.whereis_name(client)
            else
                if k < numNodes do
                    # This is the first node
                    IO.puts "This is the first node"
                    node_string = Enum.join(["node",:neighbor2])
                    node_atom = String.to_atom(node_string)
                    IO.inspect :global.whereis_name(node_atom)
                else
                    # This is the last node
                    IO.puts "This is the last node"
                    node_string = Enum.join(["node",:neighbor1])
                    node_atom = String.to_atom(node_string)
                    IO.inspect :global.whereis_name(node_atom)
                end
                
            end

        topology == "imp2D" ->
            #setImp2DTopology(numNodes)
            IO.puts "imp2D"
        true ->
            IO.puts "invalid topology option"
            System.halt(0)
    end

    
        # receive do
        #     msg ->
        #         IO.puts "Bitcoin from worker : "
        # end
    end 

end