Feature: client scp files to server
  As an online solver user
  I want to scp input and parameter files to server
  So that I can execute a job on remote server

  Scenario Outline: copy files to server
    Given I have created a client
    When I have chosen <solver> solver
    And I have specified that the number of CPU is 4
    And I have specified that input file path is /tmp/input
    And I have specified that parameter file path is /tmp/parameter
    And I have specified that SSH identity file path is <ssh_id>
    And I have started a client
    Then I should get a scp command line: <command>

  Scenarios: sdpa
    | solver   | ssh_id            | command                                                                 |
    | sdpa     | ~/.ssh/online-key | nil                                                                     |
    | sdpa     | nil               | nil                                                                     |

  Scenarios: sdpara
    | solver   | ssh_id            | command                                                                                               |
    | sdpara   | ~/.ssh/online-key | scp -i ~/.ssh/online-key /tmp/input /tmp/parameter online@sdpa01.indsys.chuo-u.ac.jp:/home/online/tmp |
    | sdpara   | nil               | scp /tmp/input /tmp/parameter online@sdpa01.indsys.chuo-u.ac.jp:/home/online/tmp                      |

  Scenarios: sdpa_ec2
    | solver   | ssh_id            | command                                                                                                              |
    | sdpa_ec2 | ~/.ssh/online-key | scp -i ~/.ssh/online-key /tmp/input /tmp/parameter online@ec2-67-202-18-171.compute-1.amazonaws.com:/home/online/tmp |
    | sdpa_ec2 | nil               | scp /tmp/input /tmp/parameter online@ec2-67-202-18-171.compute-1.amazonaws.com:/home/online/tmp                      |

  Scenarios: sdpa_gmp
    | solver   | ssh_id            | command                                                                                                  |
    | sdpa_gmp | ~/.ssh/online-key | scp -i ~/.ssh/online-key /tmp/input /tmp/parameter online@opt-laqua.indsys.chuo-u.ac.jp:/home/online/tmp |
    | sdpa_gmp | nil               | scp /tmp/input /tmp/parameter online@opt-laqua.indsys.chuo-u.ac.jp:/home/online/tmp                      |

  Scenarios: sdpa_dd
    | solver   | ssh_id            | command                                                                                                  |
    | sdpa_dd  | ~/.ssh/online-key | scp -i ~/.ssh/online-key /tmp/input /tmp/parameter online@opt-laqua.indsys.chuo-u.ac.jp:/home/online/tmp |
    | sdpa_dd  | nil               | scp /tmp/input /tmp/parameter online@opt-laqua.indsys.chuo-u.ac.jp:/home/online/tmp                      |
