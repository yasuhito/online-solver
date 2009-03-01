Given /^I have created a client$/ do
  @messenger = StringIO.new( "" )
  @client = OnlineSolver::Client.new( @messenger, true, true )
end


When /^I have chosen (.*) solver$/ do | solver |
  @solver = solver.to_sym
end


When /^I have specified that the number of CPU is (.*)$/ do | ncpu |
  @ncpu = ncpu.to_i
end


When /^I have specified that input file path is \/tmp\/input$/ do
  @input = "/tmp/input"
end


When /^I have specified that parameter file path is \/tmp\/parameter$/ do
  @parameter = "/tmp/parameter"
end


When /^I have specified that SSH identity file path is (.*)$/ do | ssh_id |
  @ssh_id = ssh_id if ssh_id != 'nil'
end


When /^I have started a client$/ do
  @client.start @solver, @input, @parameter, @ncpu, @ssh_id
end


Then /^I should get "(.*)" as a server$/ do | server |
  @client.server.should == server
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
    @client.server
  end.should raise_error( message )
end
