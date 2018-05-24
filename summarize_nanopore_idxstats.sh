#!/bin/bash

idxstats_file=$1


if [ -f $idxstats_file ]; then
	for chr in `seq 1 22`;
	do
		echo -ne "chr${chr}\t" #chromosome name
		cat ${idxstats_file} | egrep "chr${chr}[abAB]?(_random)?\b" | awk 'BEGIN {ORS="\t"} {for (i=2;i<=NF;i++) sum[i]+=$i;}; END{for (i in sum) print sum[i];}'
		echo "" #newline
	done    

	#additional chromosomes
	echo -ne "chrM\t" #chromosome name
	cat ${idxstats_file} | egrep "chrM\b" | awk 'BEGIN {ORS="\t"} {for (i=2;i<=NF;i++) sum[i]+=$i;}; END{for (i in sum) print sum[i];}' #mitochondria
	echo "" #newline

	echo -ne "chrX\t" #chromosome name
	cat ${idxstats_file} | egrep "chrX(_random)?\b" | awk 'BEGIN {ORS="\t"} {for (i=2;i<=NF;i++) sum[i]+=$i;}; END{for (i in sum) print sum[i];}' #chromosome X
	echo "" #newline

	echo -ne "chrUn\t" #chromosome name
	cat ${idxstats_file} | egrep "chrUn(_)?" | awk 'BEGIN {ORS="\t"} {for (i=2;i<=NF;i++) sum[i]+=$i;}; END{for (i in sum) print sum[i];}' #chromosome Unknown
	echo "" #newline

	if grep -q chrY "${idxstats_file}"; then
		echo -ne "chrY\t" #chromosome name
		cat ${idxstats_file} | egrep "chrY(_random)?\b" | awk 'BEGIN {ORS="\t"} {for (i=2;i<=NF;i++) sum[i]+=$i;}; END{for (i in sum) print sum[i];}' #chromosome Y
		echo "" #newline
	fi

	echo -ne "*\t" #chromosome name
	cat ${idxstats_file} | grep "*" | awk 'BEGIN {ORS="\t"} {for (i=2;i<=NF;i++) sum[i]+=$i;}; END{for (i in sum) print sum[i];}' #unmapped reads
	echo "" #newline

else
   echo "File $idxstats_file does not exist."
fi