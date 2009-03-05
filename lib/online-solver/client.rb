require 'popen3'
require 'pshell'


module OnlineSolver
  class Client
    include OnlineSolver


    def initialize messenger, options
      @messenger = messenger
      @debug = options[ :debug ]
      @dry_run = options[ :dry_run ]
    end


    def start solver, ncpu, input, parameter, ssh_id
      if @dry_run
        @messenger.puts "OnlineSolver Client Started (Dry Run)"
      else
        @messenger.puts "OnlineSolver Client Started"
      end

      @solver = solver
      @ncpu = ncpu
      @input = input
      @parameter = parameter
      @ssh_id = ssh_id

      Popen3::Shell.open do | shell |
        shell.on_stderr do | line |
          @messenger.puts line
          @messenger.flush
        end

        if scp_command
          debug scp_command if scp_command
          shell.exec scp_command unless @dry_run
        end
        debug ssh_command
        shell.exec ssh_command unless @dry_run
      end
    end


    #############################################################################
    private
    #############################################################################


    def server
      case @solver
      when :sdpa
        'laqua.indsys.chuo-u.ac.jp'
      when :sdpa_ec2
        'ec2-67-202-18-171.compute-1.amazonaws.com'
      when :sdpara
        'sdpa01.indsys.chuo-u.ac.jp'
      when :sdpa_gmp
        'opt-laqua.indsys.chuo-u.ac.jp'
      else
        raise "Invalid solver: #{ @solver }"
      end
    end


    def ssh_command
      case @solver
      when :sdpa, :sdpara
        "ssh #{ ssh_i_option }online@#{ server } #{ server_command } --input #{ input_remote } --parameter #{ parameter_remote } --solver #{ @solver } --ncpu #{ @ncpu }"
      when :sdpa_ec2, :sdpa_gmp
        "ssh #{ ssh_i_option }online@#{ server } #{ server_command } --input #{ input_remote } --parameter #{ parameter_remote } --solver #{ @solver }"
      end
    end


    def scp_command
      case @solver
      when :sdpa
        nil
      when :sdpa_ec2, :sdpara, :sdpa_gmp
        "scp #{ ssh_i_option }#{ @input } #{ @parameter } online@#{ server }:#{ temp_dir }"
      end
    end


    def input_remote
      File.join temp_dir, File.basename( @input )
    end


    def parameter_remote
      File.join temp_dir, File.basename( @parameter )
    end


    def ssh_i_option
      "-i #{ @ssh_id } " if @ssh_id
    end
  end
end
