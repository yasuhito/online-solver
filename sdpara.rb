#!/usr/bin/env ruby

require 'fileutils'


#
# 実行方法:
#   sdpara.rb CPU数 入力ファイル名 出力ファイル名 パラメータ ソルバのタイプ
#

$ncpu = ARGV[ 0 ].to_i
$in_file_name = ARGV[ 1 ]
$out_file_name = ARGV[ 2 ]
$parameter_file_name = ARGV[ 3 ]
$solver_type_num = ARGV[ 4 ].to_i
$webapp_dir = '/home/fujisawa/webapp'


################################################################################
# ソルバー
################################################################################

$solver = { 
  :sdpa6 => '/home/fujisawa/sdpa/prog/new/sdpa/sdpa6',
  :sdpara => '/home/fujisawa/sdpa/prog/new/sdpara.org/sdpara.mpich2',
  :sdpara_c => '/home/fujisawa/sdpa/prog/new/sdpara-c/sdpara-c.mpich2',
  :sdpa_intel => '/home/fujisawa/sdpa/prog/new/sdpa702/sdpa.intel.new',
  :sdpa_goto => '/home/fujisawa/sdpa/prog/new/sdpa702/sdpa.goto.new',
  :sdpa_gmp => '/home/fujisawa/sdpa/prog/new/sdpa-gmp702/sdpa_gmp.intel',
}


def solver_num2id
  {
    1 => :sdpa6,
    2 => :sdpara,
    3 => :sdpara_c,
    4 => :sdpa_intel,
    5 => :sdpa_goto,
    6 => :sdpa_gmp,
  }
end


def solver_args
  "-ds #{ in_file } -o #{ out_file } -p #{ parameter_file }"
end


################################################################################
# 作業ファイルのパス
################################################################################

def in_file
  File.join $webapp_dir, $in_file_name
end


def out_file
  File.join $webapp_dir, $out_file_name
end


def parameter_file
  File.join $webapp_dir, $parameter_file_name
end


def qsub_sh
  File.join $webapp_dir, $out_file + '.sh'
end


################################################################################
# その他
################################################################################

def setup_files
  FileUtils.rm $out_file, :force => true
  FileUtils.cp $in_file, $webapp_dir
  FileUtils.cp $parameter_file, $webapp_dir
end


def create_qsub_sh solver_type
  puts "filename = #{ qsub_sh }"

  File.open( qsub_sh, 'w' ) do | file |
    case solver_type
    when :sdpa6, :sdpa_gmp
      file.print <<-EOF
#!/bin/sh
#PBS -l ncpus=1
#PBS -l nodes=1
#{ $solver[ solver_type ] } #{ solver_args }
EOF
    when :sdpara, :sdpara_c
      file.print <<-EOF
#!/bin/sh
#PBS -l ncpus=#{ $ncpu }
#PBS -l nodes=1
cat $PBS_NODEFILE > /home/fujisawa/sdpa/prog/new/sdpara.org/node.list
mpiexec -n #{ $ncpu } #{ $solver[ solver_type ] } #{ solver_args }
EOF
    when :sdpa_intel, :sdpa_goto
      file.print <<-EOF
#!/bin/sh
#PBS -l ncpus=#{ $ncpu }
#PBS -l nodes=1
export OMP_NUM_THREADS=#{ $ncpu }
#{ $solver[ solver_type ] } #{ solver_args }
EOF
    else
      raise "We shouldn't reach here!"
    end
  end
end


def wait_until_finished
end


################################################################################
# START
################################################################################

puts "start in sdpa"
puts "solver_type = #{ solver_type_num }"

setup_files
create_qsub_sh solver_num2id[ $solver_type_num ]

system "qsub #{ qsub_sh }"
wait_until_finished

puts "finished!!"
FileUtils.cp out_file, $out_file_name

puts "end in sdpa"

