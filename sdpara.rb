#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

$LOAD_PATH.unshift File.dirname( __FILE__ )

require 'fileutils'
require 'popen3'
require 'pshell'
require 'tempfile'


################################################################################
# GLOBAL CONFIG
################################################################################

$temp_dir = '/home/online/tmp/'
Dir.chdir File.dirname( $temp_dir )


################################################################################
# Arguments
################################################################################

if ARGV.size < 4
  STDERR.puts "#{ $0 } INPUT_FILE PARAMETER_FILE SOLVER_NAME NUM_OF_CPU"
  exit 1
end

$in_file_name = ARGV[ 0 ]
$parameter_file_name = ARGV[ 1 ]
$solver_name = ARGV[ 2 ].to_sym
$ncpu = ARGV[ 3 ].to_i


################################################################################
# Solvers
################################################################################

def solver
  { 
    :sdpa => '/home/fujisawa/sdpa7.intel/sdpa.7.2.1.rev7/sdpa.7.2.1',
    :sdpara => "mpiexec -n #{ $ncpu } /home/fujisawa/sdpa-src/sdpara.7.2.1/sdpara.7.2.1",
    :sdpa_gmp => '/home/fujisawa/sdpa7.new/sdpa-gmp-7.1.2/sdpa_gmp'
  }
end


def solver_args
  "-ds #{ in_file } -o #{ out_file } -p #{ parameter_file }"
end


################################################################################
# Temporary Files and Directories
################################################################################

def out_file
  File.join $temp_dir, Process.pid.to_s
end


def in_file
  File.expand_path $in_file_name
end


def parameter_file
  File.expand_path $parameter_file_name
end


def qsub_sh
  File.expand_path out_file + '.sh'
end


def job_out_file job_id
  File.join $temp_dir, "#{ Process.pid }.sh.o#{ job_id }"
end


def setup_directory
  unless FileTest.directory?( $temp_dir )
    FileUtils.mkdir_p $temp_dir
  end
end


################################################################################
# Misc
################################################################################

def mpich_ncpus
  case $ncpu
  when 1, 2, 4, 8, 16
    1
  when 32
    2
  else
    raise 'We should not reach here!'
  end
end


def mpich_nodes
  case $ncpu
  when 1, 2, 4, 8, 16
    $ncpu
  when 32
    16
  else
    raise 'We should not reach here!'
  end
end


def create_qsub_sh
  debug_print "filename = #{ qsub_sh }"

  File.open( qsub_sh, 'w' ) do | file |
    case $solver_name
    when :sdpa
      script = <<-EOF
#!/bin/sh
#PBS -l ncpus=#{ $ncpu }
#PBS -l nodes=1
#PBS -q sdpa
export OMP_NUM_THREADS=#{ $ncpu }
#{ solver[ $solver_name ] } #{ solver_args }
EOF
    when :sdpa_gmp
      script = <<-EOF
#!/bin/sh
#PBS -l ncpus=1
#PBS -l nodes=1
#PBS -q sdpa
#{ solver[ $solver_name ] } #{ solver_args }
EOF
    when :sdpara
      script = <<-EOF
#!/bin/sh
#PBS -l ncpus=#{ mpich_ncpus }
#PBS -l nodes=#{ mpich_nodes }
#PBS -q sdpa
#{ solver[ $solver_name ] } #{ solver_args }
EOF
    else
      raise "We should not reach here!"
    end
    script.split( "\n" ).each do | each |
      debug_print '> ' + each
    end
    file.print script
  end
end


def qsub
  job_id = nil
  cmd = "qsub #{ qsub_sh }"

  Popen3::Shell.open do | shell |
    shell.on_stdout do | line |
      if /^(\d+)\..+/=~ line
        job_id = $1
        debug_print "job id = #{ job_id }"
      end
    end

    shell.on_stderr do | line |
      $stderr.puts line
    end

    shell.on_failure do
      raise 'qsub failed'
    end

    debug_print cmd
    shell.exec cmd
  end

  return job_id
end


def job_in_progress
  not ( /^ALL TIME =/=~ `tail -1 #{ out_file }`.chomp )
end


def wait_until_finish job_id
  loop do
    break if FileTest.exists?( out_file )
    sleep 1
  end

  debug_print "Waiting until #{ job_out_file( job_id ) } created ..."

  out = File.open( out_file, 'r' )
  while job_in_progress
    begin
      $stderr.print out.sysread( 1024 )
      sleep 1
    rescue EOFError
      # do nothing
    end
  end
  # 残りの読み込み
  $stderr.print out.read
end


def debug_print message
  $stderr.puts message if debug
end


def debug
  ARGV[ 4 ] == '1'
end


################################################################################
# Main
################################################################################

begin
  setup_directory
  create_qsub_sh
  wait_until_finish qsub
rescue
  $stderr.puts $!.to_s
  $!.backtrace.each do | each |
    debug_print each
  end
end
