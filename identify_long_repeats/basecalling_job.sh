#!/bin/bash
#SBATCH --job-name=biomonika
#SBATCH --output=biomonika-%j.out
#SBATCH --error=biomonika-%j.err
#SBATCH --mem-per-cpu=2G
#SBATCH --ntasks=63
#SBATCH --cpus-per-task=1

set -x
set -e

input_dir=$1
output_dir=$2

echo "input dir: " ${input_dir}
echo "output dir: " ${output_dir}

which conda
conda info

source activate /galaxy/home/biomonika/conda/nanopore_basecalling
read_fast5_basecaller.py --flowcell FLO-MIN106 --kit SQK-LSK108 --barcoding --output_format fastq --input ${input_dir} --save_path ${output_dir} --worker_threads 63
echo "Done."
