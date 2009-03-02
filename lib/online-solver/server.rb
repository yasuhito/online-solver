module OnlineSolver
  class Server
    def initialize messenger, qsub, options
      @messenger = messenger
      @qsub = qsub
      @debug = options[ :debug ]
      @dry_run = options[ :dry_run ]
    end


    def start solver, ncpu, input, output, parameter
      @solver = solver
      @ncpu = ncpu
      @input = input
      @output = output
      @parameter = parameter

      create_qsub_sh
      qsub
      wait_until_job_finished
    end


    ################################################################################
    private
    ################################################################################


    def temp_dir
      "/home/online/tmp"
    end


    def out_file
      File.join temp_dir, Process.pid.to_s
    end


    def job_in_progress
      tail = `tail -1 #{ out_file }`.chomp
      not ( /^ALL TIME =/=~ tail || /^\s*file\s+read\s+time =/=~ tail )
    end


    def wait_until_job_finished
      loop do
        break if FileTest.exists?( out_file )
        sleep 1
      end

      out = File.open( out_file, 'r' )
      while job_in_progress
        begin
          @messenger.print out.sysread( 1024 )
          sleep 1
        rescue EOFError
          # do nothing
        end
      end

      # 残りの読み込み
      @messenger.print out.read
    end


    def qsub
      Popen3::Shell.open do | shell |
        shell.on_stderr do | line |
          @messenger.puts line
        end

        @messenger.puts command if @debug
        shell.exec command unless @dry_run
      end
    end


    def command
      "qsub #{ @qsub.path }"
    end


    def mpi_ncpus
      if @ncpu == 32
        2
      else
        1
      end
    end


    def mpi_nodes
      if @ncpu == 32
        16
      else
        @ncpu
      end
    end


    def solver_path
      case @solver
      when :sdpa
        "/home/online/solver/sdpa"
      when :sdpa_ec2
        "/home/online/solver/sdpa_ec2"
      when :sdpa_gmp
        "/home/online/solver/sdpa_gmp"
      when :sdpara
        "mpiexec -n #{ @ncpu } /home/online/solver/sdpara"
      end
    end


    def solver_arguments
      "-ds #{ @input } -o #{ @output } -p #{ @parameter }"      
    end


    def create_qsub_sh
      case @solver
      when :sdpa
        @qsub.print <<-EOF
#!/bin/sh
#PBS -l ncpus=#{ @ncpu }
#PBS -l nodes=1
#PBS -q sdpa
export OMP_NUM_THREADS=#{ @ncpu }
#{ solver_path } #{ solver_arguments }
EOF
      when :sdpa_ec2
        @qsub.print <<-EOF
#!/bin/sh
#PBS -l ncpus=1
#PBS -l nodes=1
#PBS -q sdpa
#PBS -o /home/online/tmp
#PBS -e /home/online/tmp
export OMP_NUM_THREADS=1
#{ solver_path } #{ solver_arguments }
EOF
      when :sdpa_gmp
        @qsub.print <<-EOF
#!/bin/sh
#PBS -l ncpus=1
#PBS -l nodes=1
#PBS -q sdpa
#{ solver_path } #{ solver_arguments }
EOF
      when :sdpara
        @qsub.print <<-EOF
#!/bin/sh
#PBS -l ncpus=#{ mpi_ncpus }
#PBS -l nodes=#{ mpi_nodes }
#PBS -q sdpa
#{ solver_path } #{ solver_arguments }
EOF
      end
    end
  end
end
