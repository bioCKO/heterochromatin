export PATH="/nfs/brubeck.bx.psu.edu/scratch5/wilfried/src/bedtools2-master/bin:$PATH"

for a in *.mf*; do 
	echo $a; 
	awk '{print $1 "\t" ($2-1) "\t" $3}' ${a} >${a}.bed; 
done;

for a in *.bed; do 
	echo $a; 
	bedtools intersect -u -a ../table.trStart.trEnd.gff.sorted.gff -b ${a} >table.${a}.gff; 
done;

for a in table*.gff; 
	do echo $a; sort -k1,1 -k3,3 -k8,8n ${a} >${a}.sorted.gff; 
done;

for a in *sorted.gff; do 
	echo $a;  
	bedtools groupby -i ${a} -g 1,3,8 -c 3,7 -o concat | bedtools groupby -g 1,2 -c 5 -o concat | cut -f3 | sort | uniq -c | sort -rgk1 | head -n 10; 
done;