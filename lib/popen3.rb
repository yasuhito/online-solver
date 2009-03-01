module Popen3
  class Popen3
    attr_reader :pid
    attr_reader :fromchild
    attr_reader :tochild
    attr_reader :childerr


    def initialize command, options = {}
      @command = command
      @env = options[ :env ] ? options[ :env ] : { 'LC_ALL' => 'C' }
      @parent_pipe, @child_pipe = init_pipe
      @tochild, @fromchild, @childerr = @parent_pipe[ :tochild ], @parent_pipe[ :fromchild ], @parent_pipe[ :childerr ]
    end


    def wait
      Process.wait @pid
    end


    def popen3
      # Child process
      @pid = Kernel.fork do
        close_end_of @parent_pipe

        STDIN.reopen @child_pipe[ :stdin ]
        STDOUT.reopen @child_pipe[ :stdout ]
        STDERR.reopen @child_pipe[ :stderr ]

        close_end_of @child_pipe

        @env.each do | key, value |
          ENV[ key ]= value
        end

        Kernel.exec @command
      end

      # Parent process
      close_end_of @child_pipe
      @parent_pipe[ :tochild ].sync = true

      if block_given?
        begin
          return yield( @parent_pipe[ :tochild ], @parent_pipe[ :fromchild ], @parent_pipe[ :childerr ] )
        ensure
          close_end_of @parent_pipe
        end
      end
      return [ @parent_pipe[ :tochild ], @parent_pipe[ :fromchild ], @parent_pipe[ :childerr ] ]
    end


    private


    def close_end_of pipe
      pipe.each do | name, pipe |
        unless pipe.closed?
          pipe.close
        end
      end
    end


    def init_pipe
      child_stdin, tochild = IO.pipe
      fromchild, child_stdout = IO.pipe
      childerr, child_stderr = IO.pipe

      return [ { :tochild => tochild, :fromchild => fromchild, :childerr => childerr }, { :stdin => child_stdin, :stdout => child_stdout, :stderr => child_stderr } ]
    end
  end
end


module Kernel
  def popen3 command, options = {}, &block
    return Popen3::Popen3.new( command, options ).popen3( &block )
  end
  module_function :popen3
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
