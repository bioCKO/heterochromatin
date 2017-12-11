#!/bin/bash
#SBATCH -C new
#SBATCH --nodes=1
#SBATCH --ntasks=2
#SBATCH -t 0

set -e
set -x

#create folders for results if they don't exist already
mkdir -p results

filename=`basename $1`

echo "rawcounts"
#convert to counts for the frequency
time grep -v "@SRR\|unit" ${filename} | awk '{count[$3]+=1} END {for (word in count) print word, count[word]}' | sort >results/${filename}.rawcounts #+1 for each occurence of an array

echo "rawlengths"
#convert to length for the density
time grep -v "@SRR\|unit" ${filename} | awk '{count[$3]+=$7} END {for (word in count) print word, count[word]}' | sort >results/${filename}.rawlengths #+length for each occurence of an array