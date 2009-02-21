Feature: client exits with error
  As an online solver client
  I want to exit with error if invalid request arrived
  So that I can handle invalid requests

  Scenario: connect to server (solver = unknown)
    Given I am not yet connected to the server
    When I get a invalid request with solver = unknown
    Then I should say "Invalid solver: unknown"
