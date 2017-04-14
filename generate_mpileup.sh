#!/bin/bash
export PATH="/nfs/brubeck.bx.psu.edu/scratch5/wilfried/src/samtools-1.3.1:$PATH"
export PATH="/nfs/brubeck.bx.psu.edu/scratch5/wilfried/src/bedtools2-master/bin:$PATH"

#PACBIO GENERATE MPILEUP
folder_with_motifs="/nfs/brubeck.bx.psu.edu/scratch6/monika/pac_errors/latest/features10000"
#array=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 X); #chromosomes to use
array=(10); #chromosomes to use
reference="/nfs/brubeck.bx.psu.edu/scratch5/wilfried/kinetics/data/hg19_formated_by_wil.fa"


#CONVERT .mf FILES into .GFF and .BED
echo "Convertin .mf files into .gff and bed"
for motif_file in $folder_with_motifs/*.mf; do 
	echo $motif_file; 
	motif=`basename $motif_file`
	awk -v mtf=$motif '{print $1 "\t mf \t" mtf "\t" ($2) "\t" $3 "\t.\t0\t.\tkinetics"}' $motif_file | sort -k1,1 -k4,4n >${motif}.gff
	gff2bed < ${motif}.gff > ${motif}.bed
done; 


for X in "${array[@]}"; do 
	echo $X; 
	for motif_file in *.mf.bed; do 
		echo $motif_file; 
		out=`basename $motif_file`; 
		samtools mpileup chr${X}_P6.cmp.h5.bam -f $reference -l ${motif_file} -uv -t INFO/DPR >mp/${X}_${out}.mp; 
	done; 
done;

