#!/bin/bash
#SBATCH --job-name=biomonika
#SBATCH --output=NCRF_thread-nanopore.v3-%j.out
#SBATCH --error=NCRF_thread-nanopore.v3-%j.err
#SBATCH --mem-per-cpu=1G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1


set -e

file=$1
repeat=$2
repeat_sequence=$3

cat ${file} | ./NoiseCancellingRepeatFinder-0.09.03/NCRF $repeat_sequence --scoring=nanopore.v3 --stats=events --positionalevents --maxnoise=20% --minlength=100 >${file}.${repeat}.100.ncrf
cat ${file} | ./NoiseCancellingRepeatFinder-0.09.03/NCRF $repeat_sequence --scoring=nanopore.v3 --stats=events --positionalevents --maxnoise=20% --minlength=500 >${file}.${repeat}.500.ncrf

cat ${file}.${repeat}.100.ncrf | python NoiseCancellingRepeatFinder-0.09.03/error_uniformity_filter.py --method=min-max --test:matches-insertions | python NoiseCancellingRepeatFinder-0.09.03/ncrf_summary.py >${file}.${repeat}.100.filtered.stats
cat ${file}.${repeat}.500.ncrf | python NoiseCancellingRepeatFinder-0.09.03/error_uniformity_filter.py --method=min-max --test:matches-insertions | python NoiseCancellingRepeatFinder-0.09.03/ncrf_summary.py >${file}.${repeat}.500.filtered.stats

cat ${file}.${repeat}.100.ncrf | python NoiseCancellingRepeatFinder-0.09.03/ncrf_summary.py >${file}.${repeat}.100.unfiltered.stats
cat ${file}.${repeat}.500.ncrf | python NoiseCancellingRepeatFinder-0.09.03/ncrf_summary.py >${file}.${repeat}.500.unfiltered.stats

echo "Processing of file ${file} and repeat ${repeat_sequence} finished."