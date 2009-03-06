Feature: server forwards outputs to client
  In order to get remote job outputs
  I will need forwarder which forwards job outputs to client

  Scenario: server forwards outputs to client
    Given a dummy job defined
    And a server started from a client, with the dummy job
    When the client submits the dummy job
    Then the server forwards the dummy job's output to the client
