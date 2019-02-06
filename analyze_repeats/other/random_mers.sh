#!/bin/bash

set -e


for a in 39/*.fasta; do 
	echo $a
	kmerLen=`bioawk -c fastx '{print length($seq)}' $a` #length of repeat unit
	# Loop through and read two lines at a time
	cat repbase_full/full_repbase.fa | while read -r header; do
		read -r sequence
		#echo "seq: $sequence header: $header"
		echo ${kmerLen} ${header} >>${a}.repbase_matches.txt;
		cat ${a} | python fasta_hamming_min.py ${sequence} >>${a}.repbase_matches.txt; #hits to the database 
	done
done


#target=TCTGTCTAGTTTTTATATGAAGATATTCCCTTTTCCACCATAATCCTCAAAGCGCTCCAAATATCCACTTGCAGATTCTACAAAAAGAGTGTTTCCAAACTGCTCTATCAAAAGAAATGTTCAACTCTGTGAGTTGAATACACACATCACAAAGAAGTTTCTGAGAATGCT
#numTrials=$((10*1000))

#for a in 39/*.fasta; do 
#	echo "==============="
#	echo $a;
#	cat $a | python fasta_hamming_min.py ${target}; #real hit 
#	kmerLen=`bioawk -c fastx '{print length($seq)}' $a` #length of repeat unit
#	python random_fasta.py --seed=raspberry ${numTrials}x${kmerLen} | python fasta_hamming_min.py ${target} 
#done;


