require File.join( File.dirname( __FILE__ ), "/../spec_helper" )


module OnlineSolver
  describe Server do
    context 'executing a job' do
      def tmp_out_path
        File.expand_path File.join( File.dirname( __FILE__ ), "../../out" )
      end


      before :each do
        @messenger = mock( "messenger" ).as_null_object
        @shell = mock( "shell" ).as_null_object
        @qsub = mock( "qsub" ).as_null_object

        Popen3::Shell.should_receive( :open ).and_yield( @shell ).any_number_of_times
        @server = Server.new( @messenger, @qsub, :debug => true, :dry_run => false, :temp_dir => File.dirname( tmp_out_path ) )
 
        # Mocks for job output file.
        Process.should_receive( :pid ).any_number_of_times.and_return( 'out' )
        out_file = @server.__send__( :out_file )
        FileTest.should_receive( :exists? ).with( out_file ).twice.and_return( false, true )
        File.should_receive( :open ).with( out_file, 'r' ).any_number_of_times.and_return( mock( "IO" ).as_null_object )
      end


      it "should exec qsub" do
        @server.should_receive( :job_in_progress ).twice.and_return( true, false )
        @qsub.should_receive( :path ).twice.and_return( "qsub.sh" )
        @shell.should_receive( :exec ).with( "qsub qsub.sh" )
        @server.start :sdpa, 1, "INPUT", "OUTPUT", "PARAMETER"
      end


      it "should redirect outputs to messenger" do
        @server.should_receive( :job_in_progress ).twice.and_return( true, false )
        @shell.should_receive( :on_stderr ).and_yield( "STDERR" )
        @messenger.should_receive( :puts ).with( "STDERR" )
        @server.start :sdpa, 1, "INPUT", "OUTPUT", "PARAMETER"
      end


      it "should wait until job finished" do
        system "echo \"ALL TIME = 10 sec\" > #{ tmp_out_path }"
        @messenger.should_receive( :print ).once
        @server.start :sdpa, 1, "INPUT", "OUTPUT", "PARAMETER"
        FileUtils.rm_f tmp_out_path
      end
    end
  end
end

