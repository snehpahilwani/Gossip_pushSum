defmodule Worker do

  def talktoworkers(k, numNodes, topology, algorithm) do
    IO.puts "wrkr at #{k}th node started"
    receive do
        {:rumour} ->
            IO.puts "Rumour receved at #{k}th node"
            #Reporting server that rumor received
            server = :global.whereis_name(:server)
            send(server,{:receivedRumour,k})
    end

    cond do
        topology == "full" ->
            #setFullTopology(numNodes)
            IO.puts "full"
        topology == "2D" ->
            #set2DTopology(numNodes)
            IO.puts "2d"
        topology == "line" ->
            
            # IO.puts "line"
            
            # IO.puts "My neighbors are:"
            # myPid = Integer.parse(k)
            #IO.puts k

            if k > 1 && k < numNodes do
                #These are the non extreme nodes
                neighbor1 = k - 1
                neighbor2 = k + 1
                IO.puts neighbor1
                IO.puts neighbor2
                # IO.puts "These are the non extreme nodes"
                # IO.inspect :global.whereis_name(client)
            else
                if k < numNodes do
                    # This is the first node
                    neighbor2 = k+1
                    # IO.puts neighbor2
                    # IO.puts "This is the first node"
                    
                    node_string = Enum.join(["node","#{neighbor2}"]) #RHS only
                    node_atom = String.to_atom(node_string)
                    # IO.puts node_atom
                    # IO.inspect :global.whereis_name(node_atom)
                else
                    # This is the last node
                    neighbor1 = k-1
                    # IO.puts neighbor1
                    # IO.puts "This is the last node"
                   
                    node_string = Enum.join(["node","#{neighbor1}"]) #LHS only
                    node_atom = String.to_atom(node_string)
                    # IO.puts node_atom
                    # IO.inspect :global.whereis_name(node_atom)
                end
                
            end

        topology == "imp2D" ->
            #setImp2DTopology(numNodes)
            IO.puts "imp2D"
        true ->
            IO.puts "invalid topology option"
            System.halt(0)
    end

    
        
  end 

end