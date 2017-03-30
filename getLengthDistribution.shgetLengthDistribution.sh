#!/bin/bash
#SBATCH -C new
#SBATCH --ntasks=8
#SBATCH -t 0
#SBATCH --mail-type=ALL
#SBATCH --mail-user=biomonika@psu.edu

set -e
set -x

filename=$1
cat ${filename} | awk '{if ($3=="AAACATGGAAATATCTACACCGCCATCTGTAT") print;}' | sort -rgk7 >${filename}.AAACATGGAAATATCTACACCGCCATCTGTAT &

cat ${filename} | awk '{if ($3=="AATGG") print;}' | sort -rgk7 >${filename}.AATGG &

cat ${filename} | awk '{if ($3=="AAACATGGAAATATCTACACCGCTATCTCTAT") print;}' | sort -rgk7 >${filename}.AAACATGGAAATATCTACACCGCTATCTCTAT &

cat ${filename} | awk '{if ($3=="AAACATGGAAATATCTACACAGCCATCTGTAT") print;}' | sort -rgk7 >${filename}.AAACATGGAAATATCTACACAGCCATCTGTAT &

cat ${filename} | awk '{if ($3=="AAACATGGAAATATCTACACCGCTATCTGTAT") print;}' | sort -rgk7 >${filename}.AAACATGGAAATATCTACACCGCTATCTGTAT &

cat ${filename} | awk '{if ($3=="AAATATCTACACCGCTATCTGTATGAACATGG") print;}' | sort -rgk7 >${filename}.AAATATCTACACCGCTATCTGTATGAACATGG &

cat ${filename} | awk '{if ($3=="AAATATCTACACCGCCATCTGTATGAACATGG") print;}' | sort -rgk7 >${filename}.AAATATCTACACCGCCATCTGTATGAACATGG &

cat ${filename} | awk '{if ($3=="AATGGAATGTGG") print;}' | sort -rgk7 >${filename}.AATGGAATGTGG &

wait
echo "Done. Length distribution output written."
