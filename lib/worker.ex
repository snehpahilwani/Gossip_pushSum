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

    selectedList = []
    cond do
        topology == "full" ->
            selectedList = setFullTopology(numNodes)
            IO.puts "full"
        topology == "2D" ->
            selectedList = set2DTopology(k, numNodes)
            
            IO.puts "2d"
        topology == "line" ->
            IO.puts "line"
            neighbor1 = k - 1
            neighbor2 = k + 1
            if k > 1 && k < numNodes do
                #These are the non extreme nodes
                IO.puts neighbor1
                IO.puts neighbor2
                IO.puts "These are the non extreme nodes"
                selectedList = selectedList ++ [neighbor1,neighbor2]
            else
                if k < numNodes do
                    # This is the first node
                    IO.puts neighbor2
                    IO.puts "This is the first node"
                    selectedList = selectedList ++ [neighbor2]
                else
                    # This is the last node
                    IO.puts neighbor1
                    IO.puts "This is the last node"
                    selectedList = selectedList ++ [neighbor1]
                end
                
            end

        topology == "imp2D" ->
            selectedList = set2DTopology(k,numNodes)
            selectedList = selectedList ++ setFullTopology(numNodes)
            IO.inspect selectedList
            IO.puts "imp2D"
        true ->
            IO.puts "invalid topology option"
            System.halt(0)
    end
    
    listenTillTermination(9, k, selectedList)
    Process.sleep(:infinity)
    end 

    def listenTillTermination(max, k, selectedList) do
        # IO.inspect selectedList
        selectedNeighbor = Enum.random(selectedList)
        node_string = Enum.join(["node","#{selectedNeighbor}"])
        # IO.puts node_string
        node_atom = String.to_atom(node_string)
        # IO.inspect node_atom
        # IO.inspect :global.whereis_name(node_atom)
    
        send(:global.whereis_name(node_atom),{:rumour})


        if max<1 do
            IO.puts "Terminating #{k}th node"
        else
            receive do
                {:rumour} ->
                    IO.puts "Rumour receved at #{k}th node"
                    listenTillTermination(max-1, k, selectedList)
                after 0_500 ->
                    listenTillTermination(max, k, selectedList)
            end
            
        end
    end

    def nearestSquare(num) do
        round(:math.pow(Float.ceil(:math.sqrt(num)),2))
    end
    
    def setFullTopology(numNodes) do
      #IO.puts is_integer(numNodes)
      #selectedList = []
      numbers = 1..numNodes
      selectedList = Enum.to_list(numbers)
    end
  
    def set2DTopology(k,numNodes) do
      selectedList = []
      totalNodes = nearestSquare(numNodes)
      bound = round(:math.sqrt(totalNodes))
      #First corner cases
      neighborAbove = k - bound
      neighborBelow = k + bound
      neighborLeft = k - 1
      neighborRight = k + 1
      cond do
          #If any corner case in 2D
          k == 1 || k == bound || k == (bound*(bound-1)+1) || k ==:math.pow(bound,2) ->
          cond do    
              k == 1->
                  IO.puts Enum.join([neighborRight," ",neighborBelow])
                  selectedList = selectedList ++ [neighborRight,neighborBelow]
                  IO.puts "This is the top left corner node"
              k == bound ->
                  IO.puts Enum.join([neighborLeft," ",neighborBelow])
                  selectedList = selectedList ++ [neighborLeft, neighborBelow]
                  IO.puts "This is top right corner node"
              k == (bound*(bound-1)+1) ->
                  IO.puts Enum.join([neighborAbove," ",neighborRight])
                  selectedList = selectedList ++ [neighborAbove, neighborRight]
                  IO.puts "This is bottom left corner node"
              k == :math.pow(bound,2) ->
                  IO.puts Enum.join([neighborAbove," ", neighborLeft])
                  selectedList = selectedList ++ [neighborAbove,neighborLeft]
                  IO.puts "This is bottom right corner node"
          end
          # If any edge case in 2D
          k > 0 && k<=bound || k > (bound*(bound-1)+1) && k < :math.pow(bound,2) || rem(k,bound) == 1 && k>1 && k < (bound*(bound-1)+1)  || rem(k,bound)==0 && k >bound && k < :math.pow(bound,2) ->
          cond do
              # Topmost edge without corners
              k > 0 && k<=bound  ->
                  IO.puts Enum.join([neighborLeft," ", neighborBelow, " ",neighborRight])
                  selectedList = selectedList ++ [neighborLeft, neighborBelow, neighborRight]
                  IO.puts "This is topmost edge without corners"
              # Bottommost edge without corners
              k > (bound*(bound-1)+1) && k < :math.pow(bound,2) ->
                  IO.puts Enum.join([neighborLeft," ", neighborAbove, " ",neighborRight])
                  selectedList = selectedList ++ [neighborLeft, neighborAbove, neighborRight]
                  IO.puts "This is bottommost edge without corners"
              # Leftmost edge without corners
              rem(k,bound) == 1 && k>1 && k < (bound*(bound-1)+1) ->
                  IO.puts Enum.join([neighborBelow," ", neighborAbove, " ",neighborRight])
                  selectedList = selectedList ++ [neighborBelow, neighborAbove, neighborRight]
                  IO.puts "This is leftmost edge without corners"
              # Rightmost edge without corners
              rem(k,bound) == 0 && k >bound && k<:math.pow(bound,2) ->
                  IO.puts Enum.join([neighborBelow," ", neighborAbove, " ",neighborLeft])
                  selectedList = selectedList ++ [neighborBelow, neighborAbove, neighborLeft]
                  IO.puts "This is rightmost edge without corners"
          end
          true ->
              # Rest of the elements case
              IO.puts Enum.join([neighborLeft," ", neighborBelow, " ",neighborRight, " ", neighborAbove])
              selectedList = selectedList ++ [neighborLeft, neighborBelow, neighborRight, neighborAbove]
              IO.puts "Middle element"
      end
      selectedList
    end

end 