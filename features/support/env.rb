$: << File.join(File.dirname(__FILE__), "/../../lib") 
require 'rubygems'
require 'spec/expectations'
require 'online-solver'

class Qsub < StringIO
  attr_accessor :path
end
