require 'online-solver/client.rb'
require 'online-solver/server.rb'


module OnlineSolver
  def debug message
    if @debug or @dry_run
      @messenger.puts message
      @messenger.flush
    end
  end


  def online_home
    "/home/online"
  end


  def server_command
    File.join online_home, "bin/server"
  end


  def temp_dir
    File.join online_home, "tmp"
  end
end

