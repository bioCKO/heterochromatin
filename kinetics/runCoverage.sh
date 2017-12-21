#!/bin/bash
#SBATCH -C new
#SBATCH --nodes=1
#SBATCH --exclusive
#SBATCH -t 0
#SBATCH --mail-type=ALL
#SBATCH --mail-user=biomonika@psu.edu

#input: motif file as an argument

set -e
set -x

export PATH="/nfs/brubeck.bx.psu.edu/scratch5/wilfried/src/bedtools2-master/bin:$PATH"
bam_folder="/nfs/brubeck.bx.psu.edu/scratch6/monika/pac_errors/passes/sam/forward/"


motif_file=$(basename "$1")
bam="/nfs/brubeck.bx.psu.edu/scratch6/monika/pac_errors/passes/sam/forward/forward.bam"
echo ${bam}
bedtools coverage -a $1 -b $bam -d >${motif_file}.depth
bedtools groupby -i ${motif_file}.depth -g 1,4,5 -c 11 -o collapse | awk '{print $1 "\t" $2 "\t" $3 "\t" ($3-$2+1) "\t" $4}' | sed s'/,/\t/g' >${motif_file}.depth.summary

wait
echo "Depth calculation for $1 finished."

