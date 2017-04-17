#!/bin/bash
set -e
#set -x
export PATH="/nfs/brubeck.bx.psu.edu/scratch5/wilfried/src/samtools-1.3.1:$PATH"
export PATH="/nfs/brubeck.bx.psu.edu/scratch5/wilfried/src/bedtools2-master/bin:$PATH"

#PACBIO GENERATE MPILEUP
folder_with_motifs="/nfs/brubeck.bx.psu.edu/scratch6/monika/pac_errors/latest/features10000"
folder_with_var_files="/nfs/brubeck.bx.psu.edu/scratch6/monika/pac_errors/passes/mp"
array=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 X); #chromosomes to use

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
	cat ${folder_with_var_files}/*_${b}.bed.mp >${folder_with_var_files}/${b}.mp; 
	echo "Convert .mp files with mpileup output into .gff"
	python mpileup2gff.py ${folder_with_var_files}/${b}.mp > ${folder_with_var_files}/${b}.split.gff
	echo "Intersect resulting .gff with original motif coordinates"

	if [ -s ${folder_with_var_files}/${b}.split.gff ]
	then
		bedtools intersect -wa -wb -b ${folder_with_var_files}/${b}.split.gff -a ${b}.gff -loj > ${folder_with_var_files}/${b}.intersect
		echo "Collapse variants and output .collapsed files"
		python parse_intersect.py ${folder_with_var_files}/${b}.intersect | sort -k 1,1 -k2,2n > ${b}.collapsed
		python parse_and_output_frequencies.py ${b}.collapsed
	else
        echo ${folder_with_var_files}/${b}.split.gff " is empty. Collapsed file won't be created."
	fi

done;

echo "Done."
echo "====================================="
