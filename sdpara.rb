#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#
# 説明:
#   SDPA を Torque 経由で実行するためのラッパースクリプト。
#   SSH 経由で call_sdpa.rb から呼ばれる。
#
# 実行方法:
#   sdpara.rb 入力ファイル パラメータ デバッフラグ
#
# 実行例
#   % ./sdpara.rb /tmp/sdpa/medium.dat-s /tmp/sdpa/param.sdpa 1
#

$LOAD_PATH.unshift File.dirname( __FILE__ )
Dir.chdir File.dirname( __FILE__ )

require 'fileutils'
require 'popen3'
require 'pshell'
require 'tempfile'


################################################################################
# GLOBAL CONFIG
################################################################################

$webapp_dir = '/home/fujisawa/webapp'
$temp_dir = '/tmp'


################################################################################
# Arguments
################################################################################

$in_file_name = ARGV[ 0 ]
$parameter_file_name = ARGV[ 1 ]


################################################################################
# Solvers
################################################################################

# 現状では :default しか使っていない
$solver = { 
  :default => '/home/fujisawa/sdpa7.intel/sdpa.7.2.1.rev5/sdpa.rev5',
  :sdpa6 => '/home/fujisawa/sdpa/prog/new/sdpa/sdpa6',
  :sdpara => '/home/fujisawa/sdpa/prog/new/sdpara.org/sdpara.mpich2',
  :sdpara_c => '/home/fujisawa/sdpa/prog/new/sdpara-c/sdpara-c.mpich2',
  :sdpa_intel => '/home/fujisawa/sdpa/prog/new/sdpa702/sdpa.intel.new',
  :sdpa_goto => '/home/fujisawa/sdpa/prog/new/sdpa702/sdpa.goto.new',
  :sdpa_gmp => '/home/fujisawa/sdpa/prog/new/sdpa-gmp702/sdpa_gmp.intel',
}


def solver_args
  "-ds #{ in_file } -o #{ out_file } -p #{ parameter_file }"
end


################################################################################
# Temporary Files
################################################################################

def out_file
  File.join $temp_dir, 'sdpa.tmp'
end


def in_file
  File.expand_path File.join( $temp_dir, File.basename( $in_file_name ) )
end


def parameter_file
  File.expand_path File.join( $temp_dir, File.basename( $parameter_file_name ) )
end


def qsub_sh
  File.expand_path out_file + '.sh'
end


def job_out_file job_id
  File.expand_path File.join( File.dirname( __FILE__ ), "#{ File.basename( out_file ) }.sh.o#{ job_id }" )
end


################################################################################
# Misc
################################################################################

def setup_files
  unless FileTest.directory?( $webapp_dir )
    FileUtils.mkdir_p $temp_dir, :verbose => debug
  end
  FileUtils.rm out_file, :force => true, :verbose => debug
  FileUtils.cp File.expand_path( $in_file_name ), $temp_dir, :verbose => debug
  FileUtils.cp File.expand_path( $parameter_file_name ), $temp_dir, :verbose => debug
end


def create_qsub_sh
  debug_print "filename = #{ qsub_sh }"

  File.open( qsub_sh, 'w' ) do | file |
    script = <<-EOF
#!/bin/sh
#PBS -l ncpus=1
#PBS -l nodes=1
#PBS -q sdpa
export OMP_NUM_THREADS=4
#{ $solver[ :default ] } #{ solver_args }
EOF
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

    debug_print cmd
    shell.exec cmd
  end

  return job_id
end


def wait_until_finish job_id
  loop do
    break if FileTest.exists?( out_file )
    sleep 1
  end

  debug_print "Waiting until #{ job_out_file( job_id ) } created ..."

  out = File.open( out_file, 'r' )
  while ( not FileTest.exists?( job_out_file( job_id ) ) )
    begin
      $stderr.print out.sysread( 1024 )
      sleep 0.1
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
  ARGV[ 2 ] == '1'
end


################################################################################
# Main
################################################################################

begin
  setup_files
  create_qsub_sh
  wait_until_finish qsub
rescue
  $stderr.puts $!.to_s
  $!.backtrace.each do | each |
    debug_print each
  end
end
