#!/bin/bash
make
for num in {1000..9000..1000}
do
./gol "$num" inputs/1k.pbm outputs/1k.pbm -v2 -n20 -t output1ov.txt
done
for num in {10000..31000..3000}
do
./gol "$num" inputs/1k.pbm outputs/1k.pbm -v2 -n20 -t output1ov.txt
done

num=32
until [ $num -gt 1000 ]
do
./gol 1000 inputs/"$num".pbm outputs/"$num".pbm -v1 -n20 -t output2oh.txt
num=$((num * 2))
done
for num in {1..10}
do
./gol 1000 inputs/"$num"k.pbm outputs/"$num"k.pbm -v1 -n20 -t output2oh.txt
done