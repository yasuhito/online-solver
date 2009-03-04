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
    | solver   | ncpu | ssh_id            | command                                                                                                                                                                 |
    | sdpa     | 4    | ~/.ssh/online-key | ssh -i ~/.ssh/online-key online@laqua.indsys.chuo-u.ac.jp /home/online/bin/server --input /home/online/tmp/input --parameter /home/online/tmp/parameter --solver sdpa --ncpu 4 |
    | sdpa     | 1    | ~/.ssh/online-key | ssh -i ~/.ssh/online-key online@laqua.indsys.chuo-u.ac.jp /home/online/bin/server --input /home/online/tmp/input --parameter /home/online/tmp/parameter --solver sdpa --ncpu 1 |
    | sdpa     | 4    | nil               | ssh online@laqua.indsys.chuo-u.ac.jp /home/online/bin/server --input /home/online/tmp/input --parameter /home/online/tmp/parameter --solver sdpa --ncpu 4                      |
    | sdpa     | 1    | nil               | ssh online@laqua.indsys.chuo-u.ac.jp /home/online/bin/server --input /home/online/tmp/input --parameter /home/online/tmp/parameter --solver sdpa --ncpu 1                      |

  Scenarios: sdpara
    | solver   | ncpu | ssh_id            | command                                                                                                                                                                    |
    | sdpara   | 4    | ~/.ssh/online-key | ssh -i ~/.ssh/online-key online@sdpa01.indsys.chuo-u.ac.jp /home/online/bin/server --input /home/online/tmp/input --parameter /home/online/tmp/parameter --solver sdpara --ncpu 4 |
    | sdpara   | 1    | ~/.ssh/online-key | ssh -i ~/.ssh/online-key online@sdpa01.indsys.chuo-u.ac.jp /home/online/bin/server --input /home/online/tmp/input --parameter /home/online/tmp/parameter --solver sdpara --ncpu 1 |
    | sdpara   | 4    | nil               | ssh online@sdpa01.indsys.chuo-u.ac.jp /home/online/bin/server --input /home/online/tmp/input --parameter /home/online/tmp/parameter --solver sdpara --ncpu 4                      |
    | sdpara   | 1    | nil               | ssh online@sdpa01.indsys.chuo-u.ac.jp /home/online/bin/server --input /home/online/tmp/input --parameter /home/online/tmp/parameter --solver sdpara --ncpu 1                      |

  Scenarios: sdpa_ec2
    | solver   | ncpu | ssh_id            | command                                                                                                                                                                            |
    | sdpa_ec2 | 4    | ~/.ssh/online-key | ssh -i ~/.ssh/online-key online@ec2-67-202-18-171.compute-1.amazonaws.com /home/online/bin/server --input /home/online/tmp/input --parameter /home/online/tmp/parameter --solver sdpa_ec2 |
    | sdpa_ec2 | 1    | ~/.ssh/online-key | ssh -i ~/.ssh/online-key online@ec2-67-202-18-171.compute-1.amazonaws.com /home/online/bin/server --input /home/online/tmp/input --parameter /home/online/tmp/parameter --solver sdpa_ec2 |
    | sdpa_ec2 | 4    | nil               | ssh online@ec2-67-202-18-171.compute-1.amazonaws.com /home/online/bin/server --input /home/online/tmp/input --parameter /home/online/tmp/parameter --solver sdpa_ec2                      |
    | sdpa_ec2 | 1    | nil               | ssh online@ec2-67-202-18-171.compute-1.amazonaws.com /home/online/bin/server --input /home/online/tmp/input --parameter /home/online/tmp/parameter --solver sdpa_ec2                      |
 
  Scenarios: sdpa_gmp
    | solver   | ncpu | ssh_id            | command                                                                                                                                                                |
    | sdpa_gmp | 4    | ~/.ssh/online-key | ssh -i ~/.ssh/online-key online@opt-laqua.indsys.chuo-u.ac.jp /home/online/bin/server --input /home/online/tmp/input --parameter /home/online/tmp/parameter --solver sdpa_gmp |
    | sdpa_gmp | 1    | ~/.ssh/online-key | ssh -i ~/.ssh/online-key online@opt-laqua.indsys.chuo-u.ac.jp /home/online/bin/server --input /home/online/tmp/input --parameter /home/online/tmp/parameter --solver sdpa_gmp |
    | sdpa_gmp | 4    | nil               | ssh online@opt-laqua.indsys.chuo-u.ac.jp /home/online/bin/server --input /home/online/tmp/input --parameter /home/online/tmp/parameter --solver sdpa_gmp                      |
    | sdpa_gmp | 1    | nil               | ssh online@opt-laqua.indsys.chuo-u.ac.jp /home/online/bin/server --input /home/online/tmp/input --parameter /home/online/tmp/parameter --solver sdpa_gmp                      |
