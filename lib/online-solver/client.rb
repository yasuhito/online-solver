module OnlineSolver
  class Client
    attr_reader :server


    def initialize solver
      @solver = solver
      @server = get_server
    end


    def submit options
      make_request server, options
    end


    #############################################################################
    private
    #############################################################################


    def get_server
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
  end
end
