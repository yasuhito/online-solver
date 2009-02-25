Feature: ssh to server
  As an online solver user
  I want to "ssh command" to server
  So that I can submit a job to remote server via SSH

  Scenario: exec "ssh command server"
    Given I have not yet created a client
    When I have chosen sdpa_ec2 solver
    And I have specified that the number of CPU is 4
    And I have specified that input file path is /tmp/input
    And I have specified that parameter file path is /tmp/parameter
    And I have specified that SSH identity file path is ~/.ssh/online-key
    And I have created a client
    Then I should get a ssh command line: "^ssh -i ~/.ssh/online-key .* /home/online/bin/server.rb /home/online/tmp/input /home/online/tmp/parameter sdpa_ec2$"

  More Examples:
    | solver   | ncpu | ssh_id            | command                                                                                                              |
    | sdpa_ec2 | 1    | ~/.ssh/online-key | ^ssh -i ~/.ssh/online-key .* /home/online/bin/server.rb /home/online/tmp/input /home/online/tmp/parameter sdpa_ec2$  |
    | sdpa_ec2 | 4    | nil               | ^ssh .* /home/online/bin/server.rb /home/online/tmp/input /home/online/tmp/parameter sdpa_ec2$                       |
    | sdpa_ec2 | 1    | nil               | ^ssh .* /home/online/bin/server.rb /home/online/tmp/input /home/online/tmp/parameter sdpa_ec2$                       |
    | sdpara   | 4    | ~/.ssh/online-key | ^ssh -i ~/.ssh/online-key .* /home/online/bin/server.rb /home/online/tmp/input /home/online/tmp/parameter sdpara 4   |
    | sdpara   | 1    | ~/.ssh/online-key | ^ssh -i ~/.ssh/online-key .* /home/online/bin/server.rb /home/online/tmp/input /home/online/tmp/parameter sdpara 1   |
    | sdpara   | 4    | nil               | ^ssh .* /home/online/bin/server.rb /home/online/tmp/input /home/online/tmp/parameter sdpara 4                        |
    | sdpara   | 1    | nil               | ^ssh .* /home/online/bin/server.rb /home/online/tmp/input /home/online/tmp/parameter sdpara 1                        |
    | sdpa_gmp | 4    | ~/.ssh/online-key | ^ssh -i ~/.ssh/online-key .* /home/online/bin/server.rb /home/online/tmp/input /home/online/tmp/parameter sdpa_gmp$  |
    | sdpa_gmp | 1    | ~/.ssh/online-key | ^ssh -i ~/.ssh/online-key .* /home/online/bin/server.rb /home/online/tmp/input /home/online/tmp/parameter sdpa_gmp$  |
    | sdpa_gmp | 4    | nil               | ^ssh .* /home/online/bin/server.rb /home/online/tmp/input /home/online/tmp/parameter sdpa_gmp$                       |
    | sdpa_gmp | 1    | nil               | ^ssh .* /home/online/bin/server.rb /home/online/tmp/input /home/online/tmp/parameter sdpa_gmp$                       |
    | sdpa     | 4    | ~/.ssh/online-key | ^ssh -i ~/.ssh/online-key .* /home/online/bin/server.rb /home/online/tmp/input /home/online/tmp/parameter sdpa 4     |
    | sdpa     | 1    | ~/.ssh/online-key | ^ssh -i ~/.ssh/online-key .* /home/online/bin/server.rb /home/online/tmp/input /home/online/tmp/parameter sdpa 1     |
    | sdpa     | 4    | nil               | ^ssh .* /home/online/bin/server.rb /home/online/tmp/input /home/online/tmp/parameter sdpa 4                          |
    | sdpa     | 1    | nil               | ^ssh .* /home/online/bin/server.rb /home/online/tmp/input /home/online/tmp/parameter sdpa 1                          |


  Scenario: fail to exec "ssh command server"
    # TODO: CPU 数が変な値だった場合のテスト
