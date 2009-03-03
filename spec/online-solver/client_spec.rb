require File.join( File.dirname( __FILE__ ), "/../spec_helper" )


module OnlineSolver
  describe Client do
    before :each do | each |
      @messenger = mock( "messenger" ).as_null_object
    end

    
    context 'starting up' do
      it "should send a starting message" do
        @messenger.should_receive( :puts ).with( "OnlineSolver Client Started (Dry Run)" )
        client = OnlineSolver::Client.new( @messenger, :debug => true, :dry_run => true )
        client.start :sdpa, "NCPU", "INPUT", "PARAMETER", "SSH_ID"
      end
    end


    context 'about to submit a job' do
      before :each do
        @client = OnlineSolver::Client.new( @messenger, :debug => true, :dry_run => false )
        @shell = mock( "shell" ).as_null_object
        Popen3::Shell.should_receive( :open ).and_yield( @shell ).at_most( :once )
      end


      context 'to sdpa solver' do
        it "should not scp" do
          @client.should_not_receive( :exec ).with( /^scp/ )
          @client.start :sdpa, "NCPU", "INPUT", "PARAMETER", "SSH_ID"
        end
        

        it "should ssh to laqua" do
          @shell.should_receive( :exec ).with( /^ssh .* laqua.indsys.chuo-u.ac.jp/ )
          @client.start :sdpa, "NCPU", "INPUT", "PARAMETER", "SSH_ID"
        end
      end


      context 'to sdpa_ec2 solver' do
        it "should scp to EC2" do
          @shell.should_receive( :exec ).with( /^scp .* ec2-67-202-18-171.compute-1.amazonaws.com:.*/ )
          @client.start :sdpa_ec2, "NCPU", "INPUT", "PARAMETER", "SSH_ID"
        end


        it "should ssh to EC2" do
          @shell.should_receive( :exec ).with( /^ssh .* ec2-67-202-18-171.compute-1.amazonaws.com/ )
          @client.start :sdpa_ec2, "NCPU", "INPUT", "PARAMETER", "SSH_ID"
        end
      end


      context 'to sdpara solver' do
        it 'should scp to sdpa01' do
          @shell.should_receive( :exec ).with( /^scp .* sdpa01.indsys.chuo-u.ac.jp:.*/ )
          @client.start :sdpara, "NCPU", "INPUT", "PARAMETER", "SSH_ID"
        end


        it 'should ssh to sdpa01' do
          @shell.should_receive( :exec ).with( /^ssh .* sdpa01.indsys.chuo-u.ac.jp/ )
          @client.start :sdpara, "NCPU", "INPUT", "PARAMETER", "SSH_ID"
        end
      end


      context 'to sdpa_gmp solver' do
        it 'should scp to opt-laqua' do
          @shell.should_receive( :exec ).with( /^scp .* opt-laqua.indsys.chuo-u.ac.jp:.*/ )
          @client.start :sdpa_gmp, "NCPU", "INPUT", "PARAMETER", "SSH_ID"
        end


        it 'should ssh to opt-laqua' do
          @shell.should_receive( :exec ).with( /^ssh .* opt-laqua.indsys.chuo-u.ac.jp/ )
          @client.start :sdpa_gmp, "NCPU", "INPUT", "PARAMETER", "SSH_ID"
        end
      end
    end


    context 'executing a job' do
      it "should log remote job outputs" do
        messenger = StringIO.new( "" )
        @client = OnlineSolver::Client.new( messenger, :debug => true, :dry_run => true )
        @shell = mock( "shell" ).as_null_object
        @shell.should_receive( :on_stderr ).once.and_yield( "STDERR" )
        Popen3::Shell.should_receive( :open ).and_yield( @shell ).at_most( :once )
        @client.start :sdpa, "NCPU", "INPUT", "PARAMETER", "SSH_ID"
        messenger.string.split( "\n" ).should include( "STDERR" )
      end
    end
  end
end
