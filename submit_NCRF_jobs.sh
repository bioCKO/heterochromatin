#!/bin/bash
#SBATCH --job-name=biomonika
#SBATCH --output=biomonika-%j.out
#SBATCH --error=biomonika-%j.err
#SBATCH --mem-per-cpu=1G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1


set -e

for motif in /nfs/brubeck.bx.psu.edu/scratch6/monika/nanopore_run_April26th_2018/39/*.fasta; do 
	echo $motif; 
	repeat=$(basename "$motif" .fasta); 
	echo $repeat; 
	for fasta in /nfs/brubeck.bx.psu.edu/scratch6/monika/nanopore_run_April26th_2018/basecalling/*.fasta; do 
		echo $fasta; 
		repeat_sequence=`cat $motif | grep -v ">"`; 
		echo $repeat_sequence; 
		sbatch run_single_thread_of_NCRF.sh ${fasta} ${repeat} ${repeat_sequence}
	done; 
done;

echo "All NCRF jobs submitted."