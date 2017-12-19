#!/bin/bash
#SBATCH -C new
#SBATCH --nodes=1
#SBATCH --ntasks=2
#SBATCH -t 0

set -e

file_counts=$1 #input file is .rawcounts for filtering, but will calculate output both for .rawcounts and .rawlengths
file_lengths=`eval echo ${file_counts} | sed 's/counts/lengths/'`
output_dir=$2

if [[ -z "$output_dir" ]]; then
	output_file_counts=${file_counts}.sortedFilt
	output_file_lengths=`eval echo ${file_counts}.sortedFilt | sed 's/counts/lengths/'`
else
	output_file_counts=${output_dir}/${file_counts}.sortedFilt
	output_file_lengths=${output_dir}/`eval echo ${file_counts}.sortedFilt | sed 's/counts/lengths/'`
fi

echo "counts file: " $file_counts
echo "lengths file: " $file_lengths
echo "output counts file: " $output_file_counts
echo "output lengths file: " $output_file_lengths

if [[ $file_counts == *.rawcounts ]]; then
	if [ ! -f ${file} ]; then
		echo "File " ${file} "not found!"
	else
		awk '{if ($2>=100) print;}' ${file_counts} | sort >${output_file_counts}
		tmpfile=$(mktemp /tmp/${output_file_counts}.ids.XXXXXX)
		cut -d' ' -f1 ${output_file_counts} >${tmpfile}
		grep -Fwf ${tmpfile} ${file_lengths} >${output_file_lengths}
	fi
else
	echo "The input file " ${file} "is not .rawcounts as expected. Error."
fi


