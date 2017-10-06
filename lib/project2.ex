defmodule Project2 do
    def main(args) do
        if Enum.count(args) == 3 do
            {numNodes,_} = Integer.parse(Enum.at(args,0))
            topology = Enum.at(args,1)
            cond do
                topology == "full" ->
                    #setFullTopology(numNodes)
                    IO.puts "full"
                topology == "2D" ->
                    #set2DTopology(numNodes)
                    IO.puts "2d"
                topology == "line" ->
                    #setLineTopology(numNodes)
                    IO.puts "line"
                topology == "imp2D" ->
                    #setImp2DTopology(numNodes)
                    IO.puts "imp2D"
                true ->
                    IO.puts "invalid topology option"
                    System.halt(0)
            end
            algorithm = Enum.at(args,2)
            cond do
                algorithm == "gossip" ->
                    #gossip(framedTopology)
                    IO.puts "gossip"
                algorithm == "push-sum" ->
                    #pushSum(framedTopology)
                    System.halt(0)
                true ->
                    IO.puts "invalid algo option"
                    System.halt(0)
            end
        else
            IO.puts "Invalid number of arguments. Please provide ./project2 numNodes topology algorithm"
            System.halt(0)
        end
    end

    def setFullTopology(numNodes) do
        
    end
end
