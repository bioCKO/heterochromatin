reference=reference.fasta

awk '/^>/ { 
        if (c++ == 0) {print;} 
        next
    } 
    /^$/ {next} 
    {printf "%s", $0} 
    END {print ""}' $reference > concatenated.fasta;

mv $reference reference
mv concatenated.fasta reference.fasta

for length in `seq 7000 7000 14000`; do 
	echo $length; 
	array=(1 5 10)
	for cov in "${array[@]}"; do
		echo $cov;
		/Users/alice/programs/readsim-1.6/src/readsim.py sim fa --ref $reference --pre cov${cov}x.pacbio.reads.${length} --rev_strd off --tech pacbio --read_mu $length --cov_mu ${cov} &
	done
done
wait

echo "Generating reads finished, now identifying repeats."

#identify repeats
for a in *.fasta; do
	echo $a
	cat $a | /Users/alice/Desktop/projects/heterochromatin/pacbio/floopalign-distrib-0.03.07/floopalign GGAAT --minlength=500 --minmratio=70% --stats=events --fields=5,5,5,5 --progress=100K M=3 MM=7 I=3,11 D=6 --positionalevents | grep "bp" | tr -s " " | sed '/^$/d' | cut -d' ' -f3 | grep -v "score" | grep -v "querybp" | sed 's/bp//g' | sort -g >${a}.deNovoLenient &
	cat $a | /Users/alice/Desktop/projects/heterochromatin/pacbio/floopalign-distrib-0.03.07/floopalign GGAAT --minlength=500 --minmratio=70% --stats=events --fields=5,5,5,5 --progress=100K M=3 MM=12 I=4,12 D=6 --positionalevents | grep "bp" | tr -s " " | sed '/^$/d' | cut -d' ' -f3 | grep -v "score" | grep -v "querybp" | sed 's/bp//g' | sort -g >${a}.deNovoStrict &
done;

wait

echo "Done."