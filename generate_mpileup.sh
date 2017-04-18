-uv --no-BAQ --open-prob 15 -Q 0 -D -t INFO/DPR#!/bin/bash
set -e
#set -x
export PATH="/nfs/brubeck.bx.psu.edu/scratch5/wilfried/src/samtools-1.3.1:$PATH"
export PATH="/nfs/brubeck.bx.psu.edu/scratch5/wilfried/src/bedtools2-master/bin:$PATH"

#PACBIO GENERATE MPILEUP
##########################
# ./generate_mpileup.sh folder_with_motifs bam_folder results_folder
# example: 
# ./generate_mpileup.sh "/nfs/brubeck.bx.psu.edu/scratch6/monika/pac_errors/latest/features10000" "/nfs/brubeck.bx.psu.edu/scratch6/monika/pac_errors/passes/sam" "/nfs/brubeck.bx.psu.edu/scratch6/monika/pac_errors/passes/mp"
##########################

folder_with_motifs=$1			#"/nfs/brubeck.bx.psu.edu/scratch6/monika/pac_errors/latest/features10000"
bam_folder=$2					#"/nfs/brubeck.bx.psu.edu/scratch6/monika/pac_errors/passes/sam"
results_folder=$3				#"/nfs/brubeck.bx.psu.edu/scratch6/monika/pac_errors/passes/mp"

#array=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 X); #chromosomes to use
array=(20 21 22); #chromosomes to use

reference="/nfs/brubeck.bx.psu.edu/scratch5/wilfried/kinetics/data/hg19_formated_by_wil.fa"


#CONVERT .mf FILES into .GFF and .BED
echo "Convertin .mf files into .gff and bed"
echo "====================================="
for motif_file in $folder_with_motifs/*.mf; do  
	motif=`basename $motif_file`
	echo -n $motif " ";
	awk -v mtf=$motif '{print $1 "\t mf \t" mtf "\t" ($2) "\t" $3 "\t.\t0\t.\tkinetics"}' $motif_file | sort -k1,1 -k4,4n >${results_folder}/${motif}.gff
	gff2bed < ${results_folder}/${motif}.gff > ${results_folder}/${motif}.bed
done; 

#CONVERT .mf FILES into .GFF and .BED
echo "Generating mpileup using .bed files"
echo "====================================="
for X in "${array[@]}"; do 
	echo $X; 
	for motif_file in ${results_folder}/*.mf.bed; do 
		echo $motif_file; 
		out=`basename $motif_file`; 
		samtools mpileup ${bam_folder}/chr${X}_P6.cmp.h5*.bam -f $reference -l ${motif_file} -uv --no-BAQ --open-prob 15 -Q 0 -D -t INFO/DPR >${results_folder}/${X}_${out}.mp &
	done;
	wait 
done; 

echo "Parsing mpileup output (.mp files)"
echo "====================================="
