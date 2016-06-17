#!/bin/bash
#SBATCH -C new
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH -t 0
#SBATCH --mail-type=ALL
#SBATCH --mail-user=biomonika@psu.edu

set -e
set -x

while read line; do echo $line; sbatch analyze_raw_fastq.sh $line; sleep 300; done <batch_of_jobs

echo "All jobs submitted."