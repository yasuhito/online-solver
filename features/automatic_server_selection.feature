Feature: automatic server selection
  As an online solver user
  I want to get a adequate server according to my solver selection
  So that I can submit a job to the server

  Scenario: select a server
    Given I have not yet created a client
    When I have chosen sdpa solver
    And I have created a client
    Then I should get "laqua.indsys.chuo-u.ac.jp" as a server

  More Examples:
    | solver   | server                                    |
    | sdpa_ec2 | ec2-67-202-18-171.compute-1.amazonaws.com |
    | sdpara   | sdpa01.indsys.chuo-u.ac.jp                |
    | sdpa_gmp | opt-laqua.indsys.chuo-u.ac.jp             |


  Scenario: fail to select a server
    Given I have not yet created a client
    When I have chosen INVALID solver
    And I have created a client
    Then I should get an error: "Invalid solver: INVALID"
