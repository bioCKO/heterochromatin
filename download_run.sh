#!/bin/bash
#SBATCH -C new
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH -t 0
#download_run.sh SRR

set -e
set -x

/galaxy/home/biomonika/sratoolkit.2.5.7-ubuntu64/bin/fastq-dump --outdir /nfs/brubeck.bx.psu.edu/scratch5/monika/heterochromatin/great_ape_diversity/all_SRA_runs --split-files $1

echo "Download of $1 completed."