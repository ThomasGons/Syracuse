#!/bin/bash

OPT=$(getopt -o 'chms' --long 'clean,color,help,manual,synthesis')

sy=0
color="#005D70"

while true;
do
    case "$1" in
        '-c'|'--clean')
            rm -rf exe Data Images Synthesis
            exit
        ;;
        '--color')
            if [ ! -z $(echo $2 | grep -viP "^[\dabcdef]{6}$") ]
            then
                for i in $(tail -n +3 Config/refColors)
                do
                    if [ $2 = $i ]; then color=$2; break; fi
                done
                if [ $color = "#005D70" ]; then echo "Invalid color."; exit 1; fi
            else
                color="#$2"
            fi    
            shift 2
            continue 
        ;;
        '-h'|'--help')
            cat Config/help
            exit
        ;;
        '-m'|'--manual')
            man ./Config/syracuse.8.gz
            exit
        ;;
        '-s'|'--synthesis')
            sy=1; shift
            break
        ;;
        '-'|'--')
            echo -e "Missing option. Please refer to the help or the manual."; exit 1
        ;;
        *)
            if [[ $1 == *"--"* || $1 == *"-"* ]]; then echo -e "Unknown option. Please refer to the help or the manual."; exit 1; fi
            break
    esac
done

SYNTH="Synthesis/$1_$2.txt"

mkdir -p Images Data Synthesis
rm -f Images/*

if [[ -e exe || syracuse.c -nt exe ]]; then gcc syracuse.c -O3 -o exe; fi


if [ $# -ne 2 ]; then echo "This program required two bounds"; exit; fi
if [ $(echo $1$2 | grep -Po "\D" | head -n 1) ]; then echo "The terminals should be positive integers"; exit; fi 

echo -ne "Collecting data...\r"
for i in $(seq $1 $2) 
do 
    ./exe $i Data/$i.dat
    if [ $? -ne 0 ]; then exit; fi
    head -n -3 Data/$i.dat | tail -n +2 >> Data/allData.dat; echo '' >> Data/allData.dat # all Un and n for each file
    args=(`tail -n -3 Data/$i.dat | cut -d ':' -f2`)
    echo $i ${args[0]} >> Data/altitudeMax.dat
    echo $i ${args[1]} >> Data/flightDuration.dat
    echo $i ${args[2]} >> Data/altitudeDuration.dat
done

echo -e "\033[0;32mData collected.   \033[0m"

img=('allData' 'altitudeMax' 'flightDuration' 'altitudeDuration')

echo -ne "Create all graphs...\r"
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
        plot "Data/${img[i]}.dat" using 1:2 with lines lt rgb "${color}" lw 1 title "${img[i]}.dat"
EOFMarker
done
echo -e "\033[0;32mGraphs Created.\033[0m       "

rm -f ${SYNTH}

echo -ne "Generating synthesis...\r"

for i in $(seq 1 3)
do
    echo "${img[i]}:" >> $SYNTH
    NR=$(wc -l Data/${img[i]}.dat)
    echo -ne "\tavg: " >> $SYNTH ; echo "scale=2; $(awk '{ sum += $2 } END { printf sum / NR}' Data/${img[i]}.dat)" | bc -l >> $SYNTH
    UO=(`sort -g -k2 Data/${img[i]}.dat | sed -n '1p; $p' | cut -d' ' -f1`)
    MINMAX=(`sort -g -k2 Data/${img[i]}.dat | sed -n '1p; $p' | cut -d' ' -f2`)
    echo -e "\tmin: ${MINMAX[0]} (uo = ${UO[0]})" >> $SYNTH; echo -e "\tmax: ${MINMAX[1]} (uo = ${UO[1]})" >> $SYNTH
done

echo -e "\033[0;32mSynthesis generated.\033[0m   "

if [ $sy -eq 1 ]; then echo -e '\e[1m\e[4mStats\n\e[0m' ; cat ${SYNTH}; fi

rm -f Data/*

