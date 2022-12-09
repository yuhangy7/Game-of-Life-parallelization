#!/bin/bash
make
#cuda 1
for num in {1000..9000..1000}
do
./gol "$num" inputs/1k.pbm outputs/1k.pbm -v3 -t output1c1.txt
done
for num in {10000..31000..3000}
do
./gol "$num" inputs/1k.pbm outputs/1k.pbm -v3 -t output1c1.txt
done
#cuda 2
for num in {1000..9000..1000}
do
./gol "$num" inputs/1k.pbm outputs/1k.pbm -v4 -t output1c2.txt
done
for num in {10000..31000..3000}
do
./gol "$num" inputs/1k.pbm outputs/1k.pbm -v4 -t output1c2.txt
done
#cuda 3
for num in {1000..9000..1000}
do
./gol "$num" inputs/1k.pbm outputs/1k.pbm -v5 -t output1c3.txt
done
for num in {10000..31000..3000}
do
./gol "$num" inputs/1k.pbm outputs/1k.pbm -v5 -t output1c3.txt
done