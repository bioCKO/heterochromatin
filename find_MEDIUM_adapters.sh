#!/bin/bash
#SBATCH -C new
#SBATCH --nodes=1
#SBATCH --ntasks=50
#SBATCH -t 0
#SBATCH --mail-type=ALL
#SBATCH --mail-user=biomonika@psu.edu

function checkSingleAdaptor {
	name=$1
	seq=$2
	file=$3
	fgrep -c $seq ${file} | xargs echo ${name} >>${file}_MEDIUMadapt_contamination_log.txt
}

file=$1;

if [ ! -f $file ]; then
    echo "File not found!"
else
	echo "FILE PROCESSING: " $file;
	rm -f ${file}_MEDIUMadapt_contamination_log.txt; #remove previous logs

	while read line; do 
		checkSingleAdaptor ${line} ${file} &
	done <MEDIUM_contaminant_list.txt
	wait
fi

echo "Done."