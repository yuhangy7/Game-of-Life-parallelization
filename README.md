
[111214]

*** Command ***
./gol 100 inputs/1k.pbm outputs/1k.pbm -v1 -n4

100 means number of generations
inputs/1k.pbm 输入路径
outputs/1k.pbm 输出路径
-v version   0 is sequential, 1 is openmp row, 2 is openmp col, 3 is cuda
-n number threads

- initboard may appear to hang from time to time. This is because it tries to
  get a good random seed by reading from /dev/random, which may take a long
  time due to the lack of random information accumulated in the system (e.g.,
  when the machine has just been rebooted). Since randomness is not the focus
  of this homework, the program has been modified to rely on /dev/urandom (as
  opposed to /dev/random), which is consistently fast. See random_bit.c.

- Given N iterations at the command line, the current game_of_life routine
  actually returns the board after N-1 iterations, even though it computes the
  N'th iteration. In order to avoid confusing students, the routine has been
  updated to return the correct board (i.e. after N iterations).

