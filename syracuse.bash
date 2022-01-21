#!/bin/bash

SYNTH="Synthesis/minMax.txt"


mkdir -p Images Data Synthesis
rm -f Images/*

gcc syracuse.c -O3 -o exe

for i in $(seq $1 $2) 
do 
    ./exe $i Data/$i.dat
    if [ $? -ne 0 ]
    then
        exit
    fi
    head -n -3 Data/$i.dat | tail -n +2 >> Data/allData.dat; echo '' >> Data/allData.dat # all Un and n for each file
    args=(`tail -n -3 Data/$i.dat | cut -d ':' -f2`)
    echo $i ${args[0]} >> Data/altitudeMax.dat
    echo $i ${args[1]} >> Data/flightDuration.dat
    echo $i ${args[2]} >> Data/altitudeDuration.dat
done

img=('allData' 'altitudeMax' 'flightDuration' 'altitudeDuration')
rm $SYNTH

for i in $(seq 1 3)
do
    echo "${img[i]}:" >> $SYNTH
    NR=$(wc -l Data/${img[i]}.dat)
    echo -ne "\tavg: " >> $SYNTH ; echo "scale=2; $(awk '{ sum += $2 } END { printf sum / NR}' Data/${img[i]}.dat)" | bc >> $SYNTH # average
    UO=(`sort -g -k2 Data/${img[i]}.dat | sed -n '1p; $p' | cut -d' ' -f1`)
    MINMAX=(`sort -g -k2 Data/${img[i]}.dat | sed -n '1p; $p' | cut -d' ' -f2`)
    echo -e "\tmin: ${MINMAX[0]} (uo = ${UO[0]})" >> $SYNTH; echo -e "\tmax: ${MINMAX[1]} (uo = ${UO[1]})" >> $SYNTH
done

for i in $(seq 0 3)
do
        gnuplot -persist <<-EOFMarker
        set terminal png 
        set term svg size 1920,1080 font "Arial, 10"    
        set output "Images/${img[i]}.png"
        set title "${img[i]}"
        if (!${i}) {
            set xlabel "n"; set ylabel "Un"
        } else {
            set xlabel "uo"; set ylabel "${img[i]}" 
        }
        plot "Data/${img[i]}.dat" using 1:2 with lines lt rgb '#005D70' lw 1 title "${img[i]}.dat"
EOFMarker
done

echo -e '\e[1m\e[4mStats\n\e[0m' ; cat ${SYNTH}
rm -f Data/*

