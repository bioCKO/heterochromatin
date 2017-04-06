#!/bin/bash
set -e
set -x

#reformat non-B DNA annotations
for a in APhasedRepeats DirectRepeats GQuadMinus GQuadPlus InvertedRepeats MirrorRepeats ZDNAMotifs; do 
	echo $a; 
	cat $a | grep "^chr" | awk '{print $1 "\t" $4 "\t" $5 "\t" ($5-$4+1)}' | sed 's/chr//g' >${a}.clean; 
	grep "^X" ${a}.clean >${a}.X.clean; #subset X chromosome
done;

#reformat microsatellites
