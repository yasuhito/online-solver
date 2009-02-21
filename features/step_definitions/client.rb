Given /^I am not yet connected to the server$/ do
end


When /^I get a invalid request with solver = unknown$/ do
  @solver = :unknown
end


When /^I get a request with solver = "(.*)"$/ do | solver |
  @client = OnlineSolver::Client.new( solver.to_sym )
end


Then /^I should send the request to "(.*)"$/ do | server |
  @client.server.should == server
end


Then /^I should say "Invalid solver: unknown"$/ do
  lambda do
    OnlineSolver::Client.new( @solver )
  end.should raise_error( 'Invalid solver: unknown' )
end

