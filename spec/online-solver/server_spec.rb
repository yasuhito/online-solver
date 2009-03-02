require File.join( File.dirname( __FILE__ ), "/../spec_helper" )


module OnlineSolver
  describe Server do
    before :each do
      @messenger = mock( "messenger" ).as_null_object
      @shell = mock( "shell" ).as_null_object
      @qsub = mock( "qsub" ).as_null_object
      Popen3::Shell.should_receive( :open ).and_yield( @shell ).any_number_of_times
    end
    
    
    context 'executing a job' do
      before :each do
        @server = Server.new( @messenger, @qsub, :debug => true, :dry_run => false )
      end


      it "should exec qsub" do
        @server.should_receive( :wait_until_job_finished ).once
        @qsub.should_receive( :path ).twice.and_return( "qsub.sh" )
        @shell.should_receive( :exec ).with( "qsub qsub.sh" )
        @server.start :sdpa, 1, "INPUT", "OUTPUT", "PARAMETER"
      end


      it "should redirect outputs to messenger" do
        @server.should_receive( :wait_until_job_finished ).once
        @shell.should_receive( :on_stderr ).and_yield( "STDERR" )
        @messenger.should_receive( :puts ).with( "STDERR" )
        @server.start :sdpa, 1, "INPUT", "OUTPUT", "PARAMETER"
      end
    end


    context 'after qsub' do
      before :each do
        @server = Server.new( @messenger, @qsub, :debug => true, :dry_run => false, :temp_dir => File.dirname( tmp_out_path ) )
      end


      it "should wait until job started" do
        FileTest.should_receive( :exists? ).with( out_file ).twice.and_return( false, true )
        File.should_receive( :open ).with( out_file, 'r' ).any_number_of_times.and_return( mock( "IO" ).as_null_object )
        @server.should_receive( :job_in_progress ).twice.and_return( true, false )
        @server.start :sdpa, 1, "INPUT", "OUTPUT", "PARAMETER"
      end


      it "read rest of the output" do
        @server.should_receive( :out_file ).at_least( :once ).and_return( tmp_out_path )
        system %{echo "ALL TIME = 10 sec" > #{ tmp_out_path }}
        @messenger.should_receive( :print ).once.with( "ALL TIME = 10 sec\n" )
        @server.start :sdpa, 1, "INPUT", "OUTPUT", "PARAMETER"
      end


      after :each do
        FileUtils.rm_f tmp_out_path
      end


      def out_file
        @server.__send__ :out_file
      end

 
      def tmp_out_name
        "Rspec.OUT"
      end


      def tmp_out_path
        File.expand_path File.join( File.dirname( __FILE__ ), "../..", tmp_out_name )
      end
    end
  end
end
