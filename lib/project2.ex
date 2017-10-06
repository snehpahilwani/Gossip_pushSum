defmodule Project2 do
  def main(args) do
    IO.puts "Hello world"
    IO.puts args
    serveOrWork = "#{args}"
    {k, _} = Integer.parse(serveOrWork)
    loop(k)
  end


  def loop(max) do
    if max<1 do
        # IO.puts "Num : #{max}"
    else
        IO.puts "Num : #{max}"
        pid = spawn(WORKER, :talktoworkers, [max])
        IO.inspect pid
        loop(max-1)
    end
  end 


end