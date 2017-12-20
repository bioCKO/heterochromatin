#!/bin/bash
#SBATCH -C new
#SBATCH --nodes=1
#SBATCH --ntasks=2
#SBATCH -t 0

set -e
set -x

#create folders for results if they don't exist already
mkdir -p filtered
mkdir -p trf
mkdir -p fasta
mkdir -p counts

filename=`basename $1`

#filter reads for quality
/galaxy/home/biomonika/fastx/bin/fastq_quality_filter -Q33 -v -q 20 -p 100 -i $1 -o filtered/${filename}.filtered

#convert files to fasta
/galaxy/home/biomonika/seqtk/seqtk seq -A filtered/${filename}.filtered >fasta/${filename}.fasta

#run tandem repeat finder
./trf409.legacylinux64 fasta/${filename}.fasta 2 7 7 80 10 50 2000 -l 6 -f -d -h -ngs >trf/${filename}.dat

wait

#collapse the redundant repeats
python parseTRFngsKeepHeader.py trf/${filename}.dat

rm filtered/${filename}.filtered

echo "Done."