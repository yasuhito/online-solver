Feature: server creates qsub.sh
  As an online solver user
  I want to submit a job using torque
  So that my job properly scheduled

  Scenario Outline: create qsub.sh
    Given I have created a server
    When I have chosen <solver> solver
    And I have specified that the number of CPU is <ncpu>
    And I have specified that input file path is /home/online/tmp/input
    And I have specified that parameter file path is /home/online/tmp/parameter
    And I have started the server
    Then I should get qsub.sh containing line: <line>

  Scenarios: sdpa solver (ncpu = 1)
    | solver | ncpu | line                                                                                                      |
    | sdpa   | 1    | #PBS -l ncpus=1                                                                                           |
    | sdpa   | 1    | #PBS -l nodes=1                                                                                           |
    | sdpa   | 1    | #PBS -q sdpa                                                                                              |
    | sdpa   | 1    | export OMP_NUM_THREADS=1                                                                                  |
    | sdpa   | 1    | /home/online/solver/sdpa -ds /home/online/tmp/input -o /home/online/tmp/\d+ -p /home/online/tmp/parameter |

  Scenarios: sdpa solver (ncpu = 4)
    | solver | ncpu | line                                                                                                      |
    | sdpa   | 4    | #PBS -l ncpus=4                                                                                           |
    | sdpa   | 4    | #PBS -l nodes=1                                                                                           |
    | sdpa   | 4    | #PBS -q sdpa                                                                                              |
    | sdpa   | 4    | export OMP_NUM_THREADS=4                                                                                  |
    | sdpa   | 4    | /home/online/solver/sdpa -ds /home/online/tmp/input -o /home/online/tmp/\d+ -p /home/online/tmp/parameter |

  Scenarios: sdpa_ec2 solver
    | solver   | ncpu | line                                                                                                          |
    | sdpa_ec2 | nil  | #PBS -l ncpus=1                                                                                               |
    | sdpa_ec2 | nil  | #PBS -l nodes=1                                                                                               |
    | sdpa_ec2 | nil  | #PBS -q sdpa                                                                                                  |
    | sdpa_ec2 | nil  | #PBS -o /home/online/tmp                                                                                      |
    | sdpa_ec2 | nil  | #PBS -e /home/online/tmp                                                                                      |
    | sdpa_ec2 | nil  | export OMP_NUM_THREADS=1                                                                                      |
    | sdpa_ec2 | nil  | /home/online/solver/sdpa_ec2 -ds /home/online/tmp/input -o /home/online/tmp/\d+ -p /home/online/tmp/parameter |

  Scenarios: sdpa_gmp solver
    | solver   | ncpu | line                                                                                                          |
    | sdpa_gmp | nil  | #PBS -l ncpus=1                                                                                               |
    | sdpa_gmp | nil  | #PBS -l nodes=1                                                                                               |
    | sdpa_gmp | nil  | #PBS -q sdpa                                                                                                  |
    | sdpa_gmp | nil  | /home/online/solver/sdpa_gmp -ds /home/online/tmp/input -o /home/online/tmp/\d+ -p /home/online/tmp/parameter |

  Scenarios: sdpara solver (ncpus = 1)
    | solver | ncpu | line                                                                                                                     |
    | sdpara | 1    | #PBS -l ncpus=1                                                                                                          |
    | sdpara | 1    | #PBS -l nodes=1                                                                                                          |
    | sdpara | 1    | #PBS -q sdpa                                                                                                             |
    | sdpara | 1    | mpiexec -n 1 /home/online/solver/sdpara -ds /home/online/tmp/input -o /home/online/tmp/\d+ -p /home/online/tmp/parameter |

  Scenarios: sdpara solver (ncpus = 2)
    | solver | ncpu | line                                                                                                                     |
    | sdpara | 2    | #PBS -l ncpus=1                                                                                                          |
    | sdpara | 2    | #PBS -l nodes=2                                                                                                          |
    | sdpara | 2    | #PBS -q sdpa                                                                                                             |
    | sdpara | 2    | mpiexec -n 2 /home/online/solver/sdpara -ds /home/online/tmp/input -o /home/online/tmp/\d+ -p /home/online/tmp/parameter |

  Scenarios: sdpara solver (ncpus = 4)
    | solver | ncpu | line                                                                                                                     |
    | sdpara | 4    | #PBS -l ncpus=1                                                                                                          |
    | sdpara | 4    | #PBS -l nodes=4                                                                                                          |
    | sdpara | 4    | #PBS -q sdpa                                                                                                             |
    | sdpara | 4    | mpiexec -n 4 /home/online/solver/sdpara -ds /home/online/tmp/input -o /home/online/tmp/\d+ -p /home/online/tmp/parameter |

  Scenarios: sdpara solver (ncpus = 8)
    | solver | ncpu | line                                                                                                                     |
    | sdpara | 8    | #PBS -l ncpus=1                                                                                                          |
    | sdpara | 8    | #PBS -l nodes=8                                                                                                          |
    | sdpara | 8    | #PBS -q sdpa                                                                                                             |
    | sdpara | 8    | mpiexec -n 8 /home/online/solver/sdpara -ds /home/online/tmp/input -o /home/online/tmp/\d+ -p /home/online/tmp/parameter |

  Scenarios: sdpara solver (ncpus = 16)
    | solver | ncpu  | line                                                                                                                      |
    | sdpara | 16    | #PBS -l ncpus=1                                                                                                           |
    | sdpara | 16    | #PBS -l nodes=16                                                                                                          |
    | sdpara | 16    | #PBS -q sdpa                                                                                                              |
    | sdpara | 16    | mpiexec -n 16 /home/online/solver/sdpara -ds /home/online/tmp/input -o /home/online/tmp/\d+ -p /home/online/tmp/parameter |

  Scenarios: sdpara solver (ncpus = 32)
    | solver | ncpu  | line                                                                                                                      |
    | sdpara | 32    | #PBS -l ncpus=2                                                                                                           |
    | sdpara | 32    | #PBS -l nodes=16                                                                                                          |
    | sdpara | 32    | #PBS -q sdpa                                                                                                              |
    | sdpara | 32    | mpiexec -n 32 /home/online/solver/sdpara -ds /home/online/tmp/input -o /home/online/tmp/\d+ -p /home/online/tmp/parameter |
