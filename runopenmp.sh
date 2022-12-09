#openmp horinzontal
num=32
until [ $num -gt 1000 ]
do
for x in {1..24}
do 
./gol 1inputs/"$num".pbm outputs/"$num".pbm -v1 -n"$x" -t output5h.txt
done
echo "XXXXXXXXXXXXXXX\n" > output5h.txt
num=$((num * 2))
done
echo "XXXXXXXXXXXXXXX\n" > output5h.txt
for num in {1..10}
do
for x in {1..24}
do 
./gol 1inputs/"$num"k.pbm outputs/"$num"k.pbm -v1 -n"$x" -t output5h.txt
done
echo "XXXXXXXXXXXXXXX\n" > output5h.txt
done
#openmp vertical
num=32
until [ $num -gt 1000 ]
do
for x in {1..24}
do 
./gol 1inputs/"$num".pbm outputs/"$num".pbm -v2 -n"$x" -t output5v.txt
done
echo "XXXXXXXXXXXXXXX\n" > output5v.txt
num=$((num * 2))
done
echo "XXXXXXXXXXXXXXX\n" > output5v.txt
for num in {1..10}
do
for x in {1..24}
do 
./gol 1inputs/"$num"k.pbm outputs/"$num"k.pbm -v2 -n"$x" -t output5v.txt
done
echo "XXXXXXXXXXXXXXX\n" > output5v.txt
done