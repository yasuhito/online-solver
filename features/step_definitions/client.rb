Given /^I have created a client$/ do
  @messenger = StringIO.new( "" )
  @client = OnlineSolver::Client.new( @messenger, :debug => true, :dry_run => true )
end


When /^I have specified that SSH identity file path is (.*)$/ do | ssh_id |
  @ssh_id = ssh_id if ssh_id != 'nil'
end


When /^I have started a client$/ do
  @client.start @solver, @ncpu, @input, @parameter, @ssh_id
end


Then /^I should get (.*) as a server$/ do | server |
  @client.__send__( :server ).should == server
end


Then /^I should get a scp command line: (.*)$/ do | command |
  if command != 'nil'
    @messenger.string.split( "\n" ).should include( command )
  end
end


Then /^I should get a ssh command line: (.*)$/ do | command |
  @messenger.string.split( "\n" ).should include( command )
end


Then /^I should get an error: "(.*)"$/ do | message |
  lambda do
    @client.__send__ :server
  end.should raise_error( message )
end


Then /^I should get log file$/ do
  @messenger.string.split( "\n" ).size.should >= 2
end
