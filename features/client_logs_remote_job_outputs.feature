Feature: client logs remote job outputs
  As a online solver user
  I want to be forwarded remote job output
  So that I can examine remote job output locally

  Scenario: logging remote job output
    Given I have created a client
    When I have chosen sdpa solver
    And I have specified that the number of CPU is 4
    And I have specified that input file path is /tmp/input
    And I have specified that parameter file path is /tmp/parameter
    And I have specified that SSH identity file path is ~/.ssh/online-key
    And I have started a client
    Then I should get log file

