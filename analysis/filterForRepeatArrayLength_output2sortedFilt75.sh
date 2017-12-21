#!/bin/bash
#SBATCH -C new
#SBATCH --nodes=1
#SBATCH --ntasks=2
#SBATCH -t 0

set -e
set -x

file=$1
output_dir=$2

if [[ -z "$output_dir" ]]; then
	output_file=${file}.counts.sortedFilt75
else
	output_file=${output_dir}/${file}.counts.sortedFilt75
fi

if [ ! -f ${file} ]; then
	echo "File " ${file} "not found!"
else
	cat $file | awk '{if (($2-$1)>=75) {print;} }' | cut -d' ' -f3 | grep -v "unit" | sort | uniq -c | sed 's/^ *//g' | awk '{print $2 " " $1}' | sort -rgk2 | awk '{ if($2>=3) print $0}' >${output_file}
fi