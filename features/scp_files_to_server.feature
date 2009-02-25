Feature: scp files to server
  As an online solver user
  I want to scp input and parameter files to server
  So that I can execute a job on remote server

  Scenario: copy files to server
    Given I have not yet created a client
    When I have chosen sdpa_ec2 solver
    And I have specified that input file path is /tmp/input
    And I have specified that parameter file path is /tmp/parameter
    And I have specified that SSH identity file path is ~/.ssh/online-key
    And I have created a client
    Then I should get a scp command line: "^scp -i ~/.ssh/online-key /tmp/input /tmp/parameter .*:/home/online/tmp"

  More Examples:
    | solver   | ssh_id            | command                                                                 |
    | sdpa_ec2 | nil               | ^scp /tmp/input /tmp/parameter .*:/home/online/tmp                      |
    | sdpara   | ~/.ssh/online-key | ^scp -i ~/.ssh/online-key /tmp/input /tmp/parameter .*:/home/online/tmp |
    | sdpara   | nil               | ^scp /tmp/input /tmp/parameter .*:/home/online/tmp                      |
    | sdpa_gmp | ~/.ssh/online-key | ^scp -i ~/.ssh/online-key /tmp/input /tmp/parameter .*:/home/online/tmp |
    | sdpa_gmp | nil               | ^scp /tmp/input /tmp/parameter .*:/home/online/tmp                      |
    | sdpa     | ~/.ssh/online-key | nil                                                                     |
    | sdpa     | nil               | nil                                                                     |
