#openmp horinzontal
./gol 800 inputs/512.pbm outputs/512.pbm -v1 -n"$x" -t output5h.txt
for num in {1..16..2}
do
for x in {1..24}
do 
./gol 800 inputs/"$num"k.pbm outputs/"$num"k.pbm -v1 -n"$x" -t output5h.txt
done
echo "XXXXXXXXXXXXXXX\n" > output5h.txt
done
#openmp vertical
./gol 800 inputs/512.pbm outputs/512.pbm -v2 -n"$x" -t output5h.txt
for num in {1..16..2}
do
for x in {1..24}
do 
./gol 800 inputs/"$num"k.pbm outputs/"$num"k.pbm -v2 -n"$x" -t output5h.txt
done
echo "XXXXXXXXXXXXXXX\n" > output5h.txt
done