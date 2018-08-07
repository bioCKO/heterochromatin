#!/bin/bash
#SBATCH --job-name=biomonika
#SBATCH --output=NCRF_thread-%j.out
#SBATCH --error=NCRF_thread-%j.err
#SBATCH --mem-per-cpu=1G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1


set -e

file=$1
repeat=$2
repeat_sequence=$3

cat ${file} | ./NoiseCancellingRepeatFinder-master/NCRF $repeat_sequence --scoring=nanopore --stats=events --positionalevents --maxnoise=20% >${file}.${repeat}.ncrf
cat ${file}.${repeat}.ncrf | python NoiseCancellingRepeatFinder-master/ncrf_positional_filter.py --batch=25 | python NoiseCancellingRepeatFinder-master/ncrf_summary.py >${file}.${repeat}.stats

echo "Processing of file ${file} and repeat ${repeat_sequence} finished."