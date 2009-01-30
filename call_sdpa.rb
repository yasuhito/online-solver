#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#
# 説明:
#   SDPA のリモート実行用インタフェース。
#   SDPA の出力はイテレーションごとに、第三引数に指定した出力ファイルへ出力される。
#   Web インタフェース (PHP とか) はこのファイルを定期的にリロードする
#   ことで、実行中の状態を更新できる。
#
# 使い方:
#   call_sdpara.rb 入力ファイル パラメータ 出力ファイル
#
# 実行例:
#   % ./call_sdpa.rb /tmp/sdpa/medium.dat-s /tmp/sdpa/param.sdpa /tmp/out
#

$LOAD_PATH.unshift File.dirname( __FILE__ )

require 'fileutils'
require 'popen3'
require 'pshell'


################################################################################
# Global Config
################################################################################

$torque = 'laqua.indsys.chuo-u.ac.jp'


################################################################################
# Arguments
################################################################################

$input_file = ARGV[ 0 ]
$parameter_file = ARGV[ 1 ]
$out_file_name = ARGV[ 2 ]


################################################################################
# Misc
################################################################################

def sdpara
  File.expand_path File.join( File.dirname( __FILE__ ), 'sdpara.rb' )
end


def ssh_command
  ssh_identity = ENV[ 'SSH_IDENTITY' ] ? "-i #{ ENV[ 'SSH_IDENTITY' ] }": ''
  "ssh #{ ssh_identity } #{ $torque } /usr/bin/ruby #{ sdpara } #{ $input_file } #{ $parameter_file } #{ ENV[ 'DEBUG' ] ? '1' : '0' }"
end


def debug_print message
  if ENV[ 'DEBUG' ]
    $stderr.puts message
  end
end


################################################################################
# Main
################################################################################

Popen3::Shell.open do | shell |
  out = File.open( $out_file_name, 'w' )

  # SDPA の出力はバッファリングを避けるためすべて stderr で飛んでくる
  shell.on_stderr do | line |
    out.puts line
    out.flush
    debug_print line
  end

  debug_print ssh_command
  shell.exec ssh_command
end
