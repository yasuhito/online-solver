Feature: client automatically selects a server
  As an online solver user
  I want to get a adequate server according to my solver selection
  So that I can submit a job to the server

  Scenario Outline: select a server
    Given I have created a client
    When I have chosen <solver> solver
    And I have specified that the number of CPU is 4
    And I have specified that input file path is /tmp/input
    And I have specified that parameter file path is /tmp/parameter
    And I have specified that SSH identity file path is SSH_ID
    And I have started a client
    Then I should get <server> as a server

  Scenarios:
    | solver   | server                                    |
    | sdpa     | laqua.indsys.chuo-u.ac.jp                 |
    | sdpa_ec2 | ec2-67-202-18-171.compute-1.amazonaws.com |
    | sdpara   | sdpa01.indsys.chuo-u.ac.jp                |
    | sdpa_gmp | opt-laqua.indsys.chuo-u.ac.jp             |
    | sdpa_dd  | opt-laqua.indsys.chuo-u.ac.jp             |

  Scenario: fail to select a server
    Given I have created a client
    When I have chosen INVALID solver
    And I have specified that the number of CPU is 4
    And I have specified that input file path is /tmp/input
    And I have specified that parameter file path is /tmp/parameter
    And I have specified that SSH identity file path is SSH_ID
    And I have started a client
    Then I should get an error: "Invalid solver: INVALID"
