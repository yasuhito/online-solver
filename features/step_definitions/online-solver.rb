When /^I have chosen (.*) solver$/ do | solver |
  @solver = solver.to_sym
end


When /^I have specified that the number of CPU is (.*)$/ do | ncpu |
  @ncpu = ncpu.to_i
end


When /^I have specified that input file path is (.*)$/ do | path |
  @input = path
end


When /^I have specified that parameter file path is (.*)$/ do | path |
  @parameter = path
end
