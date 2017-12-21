#!/bin/bash
set -e
set -x
export PATH="/nfs/brubeck.bx.psu.edu/scratch5/wilfried/src/samtools-1.3.1:$PATH"
export PATH="/nfs/brubeck.bx.psu.edu/scratch5/wilfried/src/bedtools2-master/bin:$PATH"

#PACBIO FORMAT MPILEUP
##########################
# ./format_mpileup.sh folder_with_motifs folder_with_var_files/*.bed.mp results_folder
# example: 
# ./format_mpileup.sh "/nfs/brubeck.bx.psu.edu/scratch6/monika/pac_errors/latest/features10000" "/nfs/brubeck.bx.psu.edu/scratch6/monika/pac_errors/passes/mp_forward" "/nfs/brubeck.bx.psu.edu/scratch6/monika/pac_errors/passes/mp_forward"
##########################

#PACBIO GENERATE MPILEUP
folder_with_motifs=$1
folder_with_var_files=$2		#this folder should contain .bed.mp files from mpileup
results_folder=$3				#"/nfs/brubeck.bx.psu.edu/scratch6/monika/pac_errors/passes/mp"

#array=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 X); #chromosomes to use
array=(20 21 22); #chromosomes to use

reference="/nfs/brubeck.bx.psu.edu/scratch5/wilfried/kinetics/data/hg19_formated_by_wil.fa"


#CONVERT .mf FILES into .GFF and .BED
echo "Convertin .mp files into .collapsed"
echo "====================================="
for infile in $folder_with_motifs/*.mf; 
	do 
	b=`basename $infile`; 
	echo "====================================="
	echo ${b}
	echo "====================================="
	echo "Concatenate .bed.mp into single file for each feature"
	echo $b; 
	cat ${folder_with_var_files}/*_${b}.bed.mp | grep -v "^#" | sort >${folder_with_var_files}/${b}.mp; 
	echo "Convert .mp files with mpileup output into .gff"
	python mpileup2gff.py ${folder_with_var_files}/${b}.mp | sort -k1,1 -k4,4n > ${folder_with_var_files}/${b}.split.gff

	if [ -s ${folder_with_var_files}/${b}.split.gff ]
	then
		echo "Intersect resulting .gff with original motif coordinates"
		bedtools intersect -wa -wb -b ${folder_with_var_files}/${b}.split.gff -a ${folder_with_var_files}/${b}.gff -loj > ${folder_with_var_files}/${b}.intersect
		echo "Collapse variants and output .collapsed files"
		python parse_intersect.py ${folder_with_var_files}/${b}.intersect | sort > ${results_folder}/${b}.collapsed
		python parse_and_output_frequencies.py ${results_folder}/${b}.collapsed
	else
        echo ${folder_with_var_files}/${b}.split.gff " is empty. Collapsed file won't be created."
	fi

done;

echo "Done."
echo "====================================="
