require 'popen3'
require 'pshell'
require 'stringio'


module OnlineSolver
  class Server
    include OnlineSolver


    def initialize messenger, options
      @messenger = messenger
      @debug = options[ :debug ]
      @dry_run = options[ :dry_run ]
      @temp_dir = options[ :temp_dir ] || temp_dir
      if @dry_run and options[ :qsub ].nil?
        @qsub = StringIO.new( "" )
      else
        @qsub = options[ :qsub ] || File.open( qsub_file, 'w' )
      end
    end


    def start solver, ncpu, input, parameter
      @solver = solver
      @ncpu = ncpu
      @input = input
      @parameter = parameter
      create_qsub_sh
      qsub
      wait_until_job_finished unless @dry_run
    end


    ################################################################################
    private
    ################################################################################


    def qsub_file
      File.join @temp_dir, Process.pid.to_s + ".sh"
    end


    def out_file
      File.join @temp_dir, Process.pid.to_s
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
        @messenger.print out.sysread( 1024 ) rescue EOFError
        sleep 1
      end
      # read rest of the output
      @messenger.print out.read
    end


    def qsub
      Popen3::Shell.open do | shell |
        shell.on_stderr do | line |
          @messenger.puts line
        end

        shell.on_failure do
          raise %{Failed to exec "#{ command }"}
        end

        @messenger.puts command if @debug
        shell.exec command unless @dry_run
      end
    end


    def command
      "qsub #{ qsub_file }"
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
      "-ds #{ @input } -o #{ out_file } -p #{ @parameter }"      
    end


    def create_qsub_sh
      case @solver
      when :sdpa
        script = <<-EOF
#!/bin/sh
#PBS -l ncpus=#{ @ncpu }
#PBS -l nodes=1
#PBS -q sdpa
export OMP_NUM_THREADS=#{ @ncpu }
#{ solver_path } #{ solver_arguments }
EOF
      when :sdpa_ec2
        script = <<-EOF
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
        script = <<-EOF
#!/bin/sh
#PBS -l ncpus=1
#PBS -l nodes=1
#PBS -q sdpa
#{ solver_path } #{ solver_arguments }
EOF
      when :sdpara
        script = <<-EOF
#!/bin/sh
#PBS -l ncpus=#{ mpi_ncpus }
#PBS -l nodes=#{ mpi_nodes }
#PBS -q sdpa
#{ solver_path } #{ solver_arguments }
EOF
      end
      script.split( "\n" ).each do | each |
        @messenger.puts "> #{ each }"
      end
      @qsub.print script
      @qsub.flush
    end
  end
end
