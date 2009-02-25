require File.join( File.dirname( __FILE__ ), "/../spec_helper" )


module OnlineSolver
  describe Client do
    context 'connecting to server' do
      it "should connect to laqua if solver == 'sdpa'" do
        client = Client.new( :sdpa, "INPUT", "PARAMETER", "NCPU", "SSH_ID" )
        client.should_receive( :make_request ).with( 'laqua.indsys.chuo-u.ac.jp', 'DUMMY_JOB_PARAMETERS' )
        client.submit 'DUMMY_JOB_PARAMETERS'
      end


      it "should connect to EC2 cluster head node if solver == 'sdpa_ec2'" do
        client = Client.new( :sdpa_ec2, "INPUT", "PARAMETER", "NCPU", "SSH_ID" )
        client.should_receive( :make_request ).with( 'ec2-67-202-18-171.compute-1.amazonaws.com', 'DUMMY_JOB_PARAMETERS' )
        client.submit 'DUMMY_JOB_PARAMETERS'
      end


      it "should connect to SDPA cluster head node if solver == 'sdpara'" do
        client = Client.new( :sdpara, "INPUT", "PARAMETER", "NCPU", "SSH_ID" )
        client.should_receive( :make_request ).with( 'sdpa01.indsys.chuo-u.ac.jp', 'DUMMY_JOB_PARAMETERS' )
        client.submit 'DUMMY_JOB_PARAMETERS'
      end


      it "should connect to opt-laqua if solver == 'sdpa_gmp'" do
        client = Client.new( :sdpa_gmp, "INPUT", "PARAMETER", "NCPU", "SSH_ID" )
        client.should_receive( :make_request ).with( 'opt-laqua.indsys.chuo-u.ac.jp', 'DUMMY_JOB_PARAMETERS' )
        client.submit 'DUMMY_JOB_PARAMETERS'
      end


      it "should raise if solver is unknown" do
        lambda do
          client = Client.new( :unknown )
        end.should raise_error
      end
    end
  end
end
