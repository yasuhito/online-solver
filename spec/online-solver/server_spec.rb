require File.join( File.dirname( __FILE__ ), "/../spec_helper" )


module OnlineSolver
  describe Server do
    context 'executing a job' do
      before :each do
        @messenger = mock( "messenger" ).as_null_object
        @shell = mock( "shell" ).as_null_object
        @qsub = mock( "qsub" ).as_null_object

        Popen3::Shell.should_receive( :open ).and_yield( @shell ).any_number_of_times
        @server = Server.new( @messenger, @qsub, :debug => true, :dry_run => false )
 
        # Mocks for job output file.
        out_file = @server.__send__( :out_file )
        FileTest.should_receive( :exists? ).with( out_file ).any_number_of_times.and_return( true )
        File.should_receive( :open ).with( out_file, 'r' ).any_number_of_times.and_return( StringIO.new( "x" * ( 1024 * 2 + 1 ) ) )
        @server.should_receive( :job_in_progress ).twice.and_return( true, false )
      end


      it "should exec qsub" do
        @qsub.should_receive( :path ).twice.and_return( "qsub.sh" )
        @shell.should_receive( :exec ).with( "qsub qsub.sh" )
        @server.start :sdpa, 1, "INPUT", "OUTPUT", "PARAMETER"
      end


      it "should redirect outputs to messenger" do
        @shell.should_receive( :on_stderr ).and_yield( "STDERR" )
        @messenger.should_receive( :puts ).with( "STDERR" )
        @server.start :sdpa, 1, "INPUT", "OUTPUT", "PARAMETER"
      end


      it "should wait until job finished" do
        @messenger.should_receive( :print ).twice
        @server.start :sdpa, 1, "INPUT", "OUTPUT", "PARAMETER"
      end
    end
  end
end

