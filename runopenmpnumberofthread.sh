#!/bin/bash
#openmp number of thread
#openmp horinzontal
for num in {1..20}
do 
./gol 1000 inputs/1k.pbm outputs/1k.pbm -v1 -n"$num" -t output3h.txt
done
#openmp vertical
for num in {1..20}
do 
./gol 1000 inputs/1k.pbm outputs/1k.pbm -v2 -n"$num" -t output3v.txt
done