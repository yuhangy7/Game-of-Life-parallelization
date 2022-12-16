#!/bin/bash
make
#cuda 1
num=32
until [ $num -gt 1000 ]
do
./gol 1000 inputs/"$num".pbm outputs/"$num".pbm -v3 -t output2c1.txt
num=$((num * 2))
done
for num in {1..10}
do
./gol 1000 inputs/"$num"k.pbm outputs/"$num"k.pbm -v3 -t output2c1.txt
done
#cuda 2
num=32
until [ $num -gt 1000 ]
do
./gol 1000 inputs/"$num".pbm outputs/"$num".pbm -v4 -t output2c2.txt
num=$((num * 2))
done
for num in {1..10}
do
./gol 1000 inputs/"$num"k.pbm outputs/"$num"k.pbm -v4 -t output2c2.txt
done
#cuda 3
num=32
until [ $num -gt 1000 ]
do
./gol 1000 inputs/"$num".pbm outputs/"$num".pbm -v5 -t output2c3.txt
num=$((num * 2))
done
for num in {1..10}
do
./gol 1000 inputs/"$num"k.pbm outputs/"$num"k.pbm -v5 -t output2c3.txt
done