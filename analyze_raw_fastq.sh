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
/galaxy/home/biomonika/fastx/fastq_quality_filter -Q33 -v -q 20 -p 100 -i $1 -o filtered/${filename}.filtered

#convert files to fasta
/galaxy/home/biomonika/seqtk/seqtk seq -A filtered/${filename}.filtered >fasta/${filename}.fasta

#run tandem repeat finder
./trf409.legacylinux64 fasta/${filename}.fasta 2 7 7 80 10 50 2000 -l 6 -f -d -h -ngs >trf/${filename}.dat

wait

#collapse the redundant repeats
python parseTRFngs.py trf/${filename}.dat

#convert to counts
cat trf/${filename}.dat_output.txt | cut -d' ' -f3 | grep -v "unit" | sort | uniq -c | sed 's/^ *//g' | awk '{print $2 " " $1}' | sort -b >counts/${filename}.counts

#remove not needed files
rm filtered/${filename}.filtered
rm fasta/${filename}.fasta

echo "Analysis finished. Done."