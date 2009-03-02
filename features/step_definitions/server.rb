Given /^I have created a server$/ do
  @qsub = Qsub.new( "" )
  @messenger = StringIO.new( "" )
  @server = OnlineSolver::Server.new( @messenger, @qsub, :debug => true, :dry_run => true )
end


When /^I have specified that the qsub\.sh path is (.*)$/ do | path |
  @qsub.path = path
end


When /^I have specified that output file path is (.*)$/ do | path |
  @output = path
end


When /^I have started the server$/ do
  @server.start @solver, @ncpu, @input, @output, @parameter
end


Then /^I should get qsub.sh containing line: (.*)$/ do | line |
  @qsub.string.split( "\n" ).should include( line )
end


Then /^I should observe debug print containing qsub command line: "(.*)"$/ do | line |
  @messenger.string.split( "\n" ).should include( line )
end
