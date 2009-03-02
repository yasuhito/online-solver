Feature: server executes qsub
  As an online solver user
  I want to submit a job using torque
  So that my job properly scheduled

  # FIXME: サーバとクライアントで共通なステップを別の step_definitions/*.rb に移す
  Scenario: execute qsub
    Given I have created a server
    When I have chosen sdpa solver
    And I have specified that the qsub.sh path is /home/online/tmp/qsub.sh
    And I have specified that the number of CPU is 1
    And I have specified that input file path is /home/online/tmp/input
    And I have specified that output file path is /home/online/tmp/output
    And I have specified that parameter file path is /home/online/tmp/parameter
    And I have started the server
    Then I should observe debug print containing qsub command line: "qsub /home/online/tmp/qsub.sh"
