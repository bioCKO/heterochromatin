#!/bin/bash
#SBATCH -C new
#SBATCH --nodes=1
#SBATCH --ntasks=2
#SBATCH -t 0

if [[ ! -f most_abundant.fa ]] ; then
    echo 'File "most_abundant.fa" is not there, aborting.'
    exit
fi

grep -v ">" most_abundant.fa | sort | uniq | sort >tmp

species=(Homo Pan_troglodytes Pan_paniscus Gorilla Pongo_pygmaeus Pongo_abelii); 

for sp in "${species[@]}"; do #remove before writing
	rm -f ${sp}
done

while read mf; do #for each repeat motif
	echo $mf; 
	for sp in "${species[@]}"; do #for each species
		echo ${sp}; 
		echo -n ${mf}" " >>${sp}
		species_files=`eval echo *${sp}*joinedRepeatFreq.txt`
		#echo ${species_files}
		tmpfile=$(mktemp ${sp}.XXXXXX)
		egrep --color "\b${mf}\b" ${species_files}
		egrep --color "\b${mf}\b" ${species_files} >${tmpfile}
		awk '{ joint+=$2; forward+=$3 } END {if (forward!=0) {printf (joint/forward)*100}}' ${tmpfile} >>${sp} #joint/forward
		echo "" >>${sp}
		rm -f ${tmpfile}
	done
done <tmp

#MERGE INTO SINGLE TABLE
function multijoin() {
    out=$1
    shift 1
    cat $1 | awk '{print $1}' > $out
    echo "out" ${out}
    #for f in $*; do echo "f" ${f}; join $out $f > tmp; mv tmp $out; done
    for f in $*; do echo "f" ${f}; join -a1 -a2 -o auto -e "NA" $out $f > tmp; mv tmp $out; done
}

multijoin species.table.txt ${species[@]}
echo "repeat_motif" ${species[@]} >species.table.txt.with.header.txt
cat species.table.txt >>species.table.txt.with.header.txt
rm -f tmp

echo "DONE"