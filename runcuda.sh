#!/bin/bash

#cuda 3
for x in {4..32}
do
    for y in {4..32} 
    do
    num=$((x * y))
    if [ $num -le 1024 ]
    then
    #echo "$x,$y,$num"
    ./gol 1000 inputs/10k.pbm outputs/10k.pbm -v5 -x "$x" -y "$y" -p1 -t output4.txt 
    fi
    done
done
