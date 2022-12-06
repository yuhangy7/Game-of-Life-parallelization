#!/bin/bash
num=32
until [ $num -gt 1000 ]
do
./initboard "$num" "$num" > "$num".pbm
num=$((num * 2))
done
for num in {1..10}
do
size=$((num * 1000))
./initboard "$size" "$size" > "$num"k.pbm
done
