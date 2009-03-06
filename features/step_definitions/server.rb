Given /^I have created a server$/ do
  @qsub = StringIO.new( "" )
  @messenger = StringIO.new( "" )
  @server = OnlineSolver::Server.new( @messenger, :qsub => @qsub, :debug => true, :dry_run => true )
end


Given /^a dummy job defined$/ do
  @dummy_job_out = <<-EOF
JOB OUTPUT LINE 1
JOB OUTPUT LINE 2
JOB OUTPUT LINE 3
ALL TIME = 10 sec.
EOF
end


Given /^a server started from a client, with the dummy job$/ do
  @qsub = StringIO.new( "" )
  @messenger = StringIO.new( "" )
  out = Tempfile.open( "online_solver" )
  out.print @dummy_job_out
  out.close
  @server = OnlineSolver::Server.new( @messenger, :qsub => @qsub, :out_file => out.path, :debug => true, :dry_run => true )
end


When /^the client submits the dummy job$/ do
  @server.start :sdpa, 1, 'INPUT', 'PARAMETER'
end


When /^I have started the server$/ do
  @server.start @solver, @ncpu, @input, @parameter
end


Then /^the server forwards the dummy job's output to the client$/ do #'
  @messenger.string.split( "\n" ).should include( "JOB OUTPUT LINE 1" )
  @messenger.string.split( "\n" ).should include( "JOB OUTPUT LINE 2" )
  @messenger.string.split( "\n" ).should include( "JOB OUTPUT LINE 3" )
  @messenger.string.split( "\n" ).should include( "ALL TIME = 10 sec." )
end


Then /^I should get qsub.sh containing line: (.*)$/ do | exp |
  @qsub.string.split( "\n" ).inject( false ) do | result, each |
    result ||= Regexp.new( exp )=~ each
  end.should be_true
end


Then /^I should observe debug print containing qsub command line: "(.*)"$/ do | exp |
  @messenger.string.split( "\n" ).inject( false ) do | result, each |
    result ||= Regexp.new( exp )=~ each
  end.should be_true
end
