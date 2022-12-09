#!/bin/bash
for num in {11..16}
do
size=$((num * 1000))
./initboard "$size" "$size" > "$num"k.pbm
done
