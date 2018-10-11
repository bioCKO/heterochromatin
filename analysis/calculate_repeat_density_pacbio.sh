#!/bin/bash

declare -a species_array=("Bonobo" "BorneanOrangutan" "Chimpanzee" "Gorilla" "Human" "SumatranOrangutan")

return_total_bps_in_sample()
{
  species=$1

  if [ "$species" = "Human" ]; then
    echo 1082238511
  fi

  if [ "$species" = "Chimpanzee" ]; then
    echo 3261732462
  fi

  if [ "$species" = "Gorilla" ]; then
    echo 3602565804
  fi

  if [ "$species" = "SumatranOrangutan" ]; then
    echo 2237886885
  fi

}

echo "AATGGAGTGGAGTGG AATGGAATGGAGTGG AATGGAGTGG ACTCC AAAG AATGG AATCGAATGGAATGG AATCATCATCGAATGGAATCGAATGG AATCATCGAATGGAATCGAATGG AAATGGAATCGAATGGAATCATC AAACATGGAAATATCTACACCGCTATCTGTAT AAACATGGAAATATCTACACCGCCATCTGTAT AAACATGGAAATATCTACACTGCCATCTGTAT AAACATGGAAATATCTACACCGCGATCTGTAT AAACATGGAAATATCTACACAGCCATCTGTAT AAACATGGAAATATCTACACCGCTATCTCTAT AAACATGGAAATATCTACACCACCATCTGTAT AAACATGGAAATATCTACACCACTATCTGTAT AAACATGGAAATATCTACACCGCTATCTGTGT AAACATGGAAATATCTACACTGCTATCTGTAT AAACATGGAAATATCTACACCGCCATCTCTAT AAATATCTACACCGCTATCTGTATGAACATGG AAATATCTACACCGCCATCTGTATGAACATGG AAATGGAATCGAATGGAATCATCATC AATCATCGAATGGACTCGAATGG AAATGGACTCGAATGGAATCATC AAACATGTAAATATTTACACAGAATCTGTAT AAGTGGAATGG AAATATCTACACAGCTATCTGTATGAACATGG AAATATCTACACCACTATCTGTATGAACATGG AAATATCTACACCGCTATCTGCATGAACATGG AATCATCATGAATGGAATCGAATGG AATGGAATGTGG AAATGGAATCGAATGTAATCATCATC AATGGAATGGAATGGAATGTGG AATGGAATGGAATGTGG AACGTGGAATGG AATGGAATGTG AAAGTGGAATGG " >species.density.calculation

for species in "${species_array[@]}"
do
	start=1
	end=39
	for ((i=start; i<=end; i++))
	do
		echo  ""
		echo "i: $i"
		inputFile=${species}.fasta.rep${i}.stats
		echo `ls ${inputFile}`
		repeat_bps=`cat ${inputFile} | grep -v "#" | cut -f8 | awk '{s+=$1} END {print s}'`
		if [ -z ${repeat_bps} ]; then echo "repeat_bps is unset, set to 0"; repeat_bps=0; else echo "repeat_bps is set to '$repeat_bps'"; fi
		read_bps=`return_total_bps_in_sample ${species}`
		echo "total bps per species is " ${read_bps}
		#read_bps=`cat ${species}.fasta.rep${i}.stats | grep -v "#" | cut -f7 | awk '{s+=$1} END {print s}'` #this is from the reads that contain repeats
		repeat_density=`echo ${repeat_bps} ${read_bps}| awk '{ print $1/$2*1000000 }'`
		echo "calculated repeat density: " ${repeat_density}
		echo ${repeat_density} >${species}.${i}.density
	done
	echo -ne ${species} "" >>species.density.calculation
	for file in ${species}.{1..39}.density; do cat $file; done | tr '\n' ' ' >>species.density.calculation
	echo "" >>species.density.calculation
done

