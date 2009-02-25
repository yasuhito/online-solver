Given /^I have not yet created a client$/ do
  @client = nil
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


When /^I have created a client$/ do
  @ncpu ||= 0
  @client = OnlineSolver::Client.new( @solver, @input, @parameter, @ncpu, @ssh_id )
end


Then /^I should get "(.*)" as a server$/ do | server |
  @client.server.should == server
end


Then /^I should get a scp command line: "(.*)"$/ do | exp |
  if exp == 'nil'
    @client.scp_command.should be_nil
  else
    @client.scp_command.should match( Regexp.new( exp ) )
  end
end


Then /^I should get a ssh command line: "(.*)"$/ do | exp |
  @client.ssh_command.should match( Regexp.new( exp ) )
end


Then /^I should get an error: "(.*)"$/ do | message |
  lambda do
    @client.server
  end.should raise_error( message )
end
