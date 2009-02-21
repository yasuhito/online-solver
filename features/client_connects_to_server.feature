Feature: client connects to server
  As an online solver client
  I want to connect to proper online solver server
  So that I can submit a job to the server

  Scenario: connect to server (solver = sdpa)
    Given I am not yet connected to the server
    When I get a request with solver = "sdpa"
    Then I should send the request to "laqua.indsys.chuo-u.ac.jp"

  Scenario: connect to server (solver = sdpa_ec2)
    Given I am not yet connected to the server
    When I get a request with solver = "sdpa_ec2"
    Then I should send the request to "ec2-67-202-18-171.compute-1.amazonaws.com"

  Scenario: connect to server (solver = sdpara)
    Given I am not yet connected to the server
    When I get a request with solver = "sdpara"
    Then I should send the request to "sdpa01.indsys.chuo-u.ac.jp"

  Scenario: connect to server (solver = sdpa_gmp)
    Given I am not yet connected to the server
    When I get a request with solver = "sdpa_gmp"
    Then I should send the request to "opt-laqua.indsys.chuo-u.ac.jp"
