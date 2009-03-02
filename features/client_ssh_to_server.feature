Feature: cilent ssh to server
  As an online solver user
  I want to "ssh command" to server
  So that I can submit a job to remote server via SSH

  Scenario Outline: exec "ssh command server"
    Given I have created a client
    When I have chosen <solver> solver
    And I have specified that the number of CPU is <ncpu>
    And I have specified that input file path is /tmp/input
    And I have specified that parameter file path is /tmp/parameter
    And I have specified that SSH identity file path is <ssh_id>
    And I have started a client
    Then I should get a ssh command line: <command>

  Scenarios: sdpa
    | solver   | ncpu | ssh_id            | command                                                                                                              |
    | sdpa     | 4    | ~/.ssh/online-key | ssh -i ~/.ssh/online-key laqua.indsys.chuo-u.ac.jp /home/online/bin/server.rb /home/online/tmp/input /home/online/tmp/parameter sdpa 4     |
    | sdpa     | 1    | ~/.ssh/online-key | ssh -i ~/.ssh/online-key laqua.indsys.chuo-u.ac.jp /home/online/bin/server.rb /home/online/tmp/input /home/online/tmp/parameter sdpa 1     |
    | sdpa     | 4    | nil               | ssh laqua.indsys.chuo-u.ac.jp /home/online/bin/server.rb /home/online/tmp/input /home/online/tmp/parameter sdpa 4                          |
    | sdpa     | 1    | nil               | ssh laqua.indsys.chuo-u.ac.jp /home/online/bin/server.rb /home/online/tmp/input /home/online/tmp/parameter sdpa 1                          |

  Scenarios: sdpara
    | solver   | ncpu | ssh_id            | command                                                                                                              |
    | sdpara   | 4    | ~/.ssh/online-key | ssh -i ~/.ssh/online-key sdpa01.indsys.chuo-u.ac.jp /home/online/bin/server.rb /home/online/tmp/input /home/online/tmp/parameter sdpara 4   |
    | sdpara   | 1    | ~/.ssh/online-key | ssh -i ~/.ssh/online-key sdpa01.indsys.chuo-u.ac.jp /home/online/bin/server.rb /home/online/tmp/input /home/online/tmp/parameter sdpara 1   |
    | sdpara   | 4    | nil               | ssh sdpa01.indsys.chuo-u.ac.jp /home/online/bin/server.rb /home/online/tmp/input /home/online/tmp/parameter sdpara 4                        |
    | sdpara   | 1    | nil               | ssh sdpa01.indsys.chuo-u.ac.jp /home/online/bin/server.rb /home/online/tmp/input /home/online/tmp/parameter sdpara 1                        |

  Scenarios: sdpa_ec2
    | solver   | ncpu | ssh_id            | command                                                                                                              |
    | sdpa_ec2 | 4    | ~/.ssh/online-key | ssh -i ~/.ssh/online-key ec2-67-202-18-171.compute-1.amazonaws.com /home/online/bin/server.rb /home/online/tmp/input /home/online/tmp/parameter sdpa_ec2  |
    | sdpa_ec2 | 1    | ~/.ssh/online-key | ssh -i ~/.ssh/online-key ec2-67-202-18-171.compute-1.amazonaws.com /home/online/bin/server.rb /home/online/tmp/input /home/online/tmp/parameter sdpa_ec2  |
    | sdpa_ec2 | 4    | nil               | ssh ec2-67-202-18-171.compute-1.amazonaws.com /home/online/bin/server.rb /home/online/tmp/input /home/online/tmp/parameter sdpa_ec2                       |
    | sdpa_ec2 | 1    | nil               | ssh ec2-67-202-18-171.compute-1.amazonaws.com /home/online/bin/server.rb /home/online/tmp/input /home/online/tmp/parameter sdpa_ec2                       |
 
  Scenarios: sdpa_gmp
    | solver   | ncpu | ssh_id            | command                                                                                                              |
    | sdpa_gmp | 4    | ~/.ssh/online-key | ssh -i ~/.ssh/online-key opt-laqua.indsys.chuo-u.ac.jp /home/online/bin/server.rb /home/online/tmp/input /home/online/tmp/parameter sdpa_gmp  |
    | sdpa_gmp | 1    | ~/.ssh/online-key | ssh -i ~/.ssh/online-key opt-laqua.indsys.chuo-u.ac.jp /home/online/bin/server.rb /home/online/tmp/input /home/online/tmp/parameter sdpa_gmp  |
    | sdpa_gmp | 4    | nil               | ssh opt-laqua.indsys.chuo-u.ac.jp /home/online/bin/server.rb /home/online/tmp/input /home/online/tmp/parameter sdpa_gmp                       |
    | sdpa_gmp | 1    | nil               | ssh opt-laqua.indsys.chuo-u.ac.jp /home/online/bin/server.rb /home/online/tmp/input /home/online/tmp/parameter sdpa_gmp                       |
