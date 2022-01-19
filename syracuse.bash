#!/bin/bash

mkdir -p Images Data

rm -f Images/*

gcc syracuse.c -O3 -o exe

for i in $(seq $1 $2) 
do 
    ./exe $i Data/$i.dat
    args=(`tail -n -3 Data/$i.dat | cut -d ':' -f2`)
    echo $i ${args[0]} >> Data/altitudeMax.dat
    echo $i ${args[1]} >> Data/flightDuration.dat
    echo $i ${args[2]} >> Data/altitudeDuration.dat
done

img=('altitudeMax' 'flightDuration' 'altitudeDuration')

for i in $(seq 0 3)
do
    bg gnuplot -persist <<-EOFMarker
        set terminal png
        set term svg size 800,400 font "Arial, 10"    
        set output "Images/${img[i]}.png"
        set title "${img[i]}"
        set xlabel "Uo"
        set ylabel "${img[i]}"
        plot "Data/${img[i]}.dat" using 1:2 with lines lt rgb '#005D70' lw 1 title "${img[i]}.dat"
EOFMarker
done

rm -f Data/*
