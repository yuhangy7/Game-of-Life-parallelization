#!/bin/bash

#openmp horinzontal
./gol 800 inputs/512.pbm outputs/512.pbm -v1 -n"$x" -t output5h.txt
num=1
until [ $num -gt 16 ]
do
    for x in {1..24}
    do 
    ./gol 800 inputs/"$num"k.pbm outputs/"$num"k.pbm -v1 -n"$x" -t output5h.txt
    done
    num=$((num * 2))
    echo "XXXXXXXXXXXXXXX" > output5h.txt
done

#openmp vertical
./gol 800 inputs/512.pbm outputs/512.pbm -v2 -n"$x" -t output5v.txt
num=1
until [ $num -gt 16 ]
do
    for x in {1..24}
    do 
    ./gol 800 inputs/"$num"k.pbm outputs/"$num"k.pbm -v2 -n"$x" -t output5v.txt
    done
    num=$((num * 2))
    echo "XXXXXXXXXXXXXXX" > output5v.txt
done

