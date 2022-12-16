#!/bin/bash
#complile files
make

# Number of Generation: 1000-9000 step1000  10000-30000 step 3000
#run sequential 
for num in {1000..9000..1000}
do
./gol "$num" inputs/1k.pbm outputs/1k.pbm -v0 -t output1s.txt
done
for num in {10000..31000..3000}
do
./gol "$num" inputs/1k.pbm outputs/1k.pbm -v0 -t output1s.txt
done
#openmp horinzontal
for num in {1000..9000..1000}
do
./gol "$num" inputs/1k.pbm outputs/1k.pbm -v1 -t output1oh.txt
done
for num in {10000..31000..3000}
do
./gol "$num" inputs/1k.pbm outputs/1k.pbm -v1 -t output1oh.txt
done
#openmp vertical
for num in {1000..9000..1000}
do
./gol "$num" inputs/1k.pbm outputs/1k.pbm -v2 -t output1ov.txt
done
for num in {10000..31000..3000}
do
./gol "$num" inputs/1k.pbm outputs/1k.pbm -v2 -t output1ov.txt
done


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

#matrix size 
#run sequential 
num=32
until [ $num -gt 1000 ]
do
./gol 1000 inputs/"$num".pbm outputs/"$num".pbm -v0 -t output2s.txt
num=$((num * 2))
done
for num in {1..10}
do
./gol 1000 inputs/"$num"k.pbm outputs/"$num"k.pbm -v0 -t output2s.txt
done
#openmp horinzontal
num=32
until [ $num -gt 1000 ]
do
./gol 1000 inputs/"$num".pbm outputs/"$num".pbm -v1 -t output2oh.txt
num=$((num * 2))
done
for num in {1..10}
do
./gol 1000 inputs/"$num"k.pbm outputs/"$num"k.pbm -v1 -t output2oh.txt
done
#openmp vertical
num=32
until [ $num -gt 1000 ]
do
./gol 1000 inputs/"$num".pbm outputs/"$num".pbm -v2 -t output2ov.txt
num=$((num * 2))
done
for num in {1..10}
do
./gol 1000 inputs/"$num"k.pbm outputs/"$num"k.pbm -v2 -t output2ov.txt
done
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