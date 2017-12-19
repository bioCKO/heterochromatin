set -e
#set -x


#MERGING
pattern=*sortedFilt

echo "Pattern: " ${pattern}

ls ${pattern} | tr -s " " | cut -d' ' -f9 | xargs echo -n | awk '{print "unit "$0}' >header.txt

function multijoin() {
    out=$1
    shift 1
    cat $1 | awk '{print $1}' > $out
    echo "out" ${out}
    #for f in $*; do echo "f" ${f}; join $out $f > tmp; mv tmp $out; done
    for f in $*; do echo "f" ${f}; join -a1 -a2 -o auto -e "NA" $out $f > tmp; mv tmp $out; done
}

multijoin big.table.txt ${pattern}

cat header.txt big.table.txt >big.table.with.header.txt; 

echo "header"; awk -F' ' '{print NF}' header.txt | sort | uniq -c; echo "table"; awk -F' ' '{print NF}' big.table.with.header.txt | sort | uniq -c

echo "Perform checks for consistency between original data and joined table:"
cat big.table.with.header.txt | sed s'/,/ /g' | tr -s " " | cut -d' ' -f2- | tr " " "\n" | grep -v '^$' | awk '{s+=$1} END {print s}'
cat ${pattern} | cut -d' ' -f2 | awk '{s+=$1} END {print s}'

echo "Perform check for number of repeat units used:"
cut -d' ' -f1 ${pattern} | sort | uniq | awk '{print $1 " 0"}' >All_repeat_units.sortedFilt 
wc -l All_repeat_units.sortedFilt 
wc -l big.table.txt
wc -l big.table.with.header.txt
