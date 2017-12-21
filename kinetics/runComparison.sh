export PATH="/nfs/brubeck.bx.psu.edu/scratch5/wilfried/src/samtools-1.3.1:$PATH"
export PATH="/nfs/brubeck.bx.psu.edu/scratch5/wilfried/src/bedtools2-master/bin:$PATH"

a=1; #chromosome 1 

#FEATURE
bedtools coverage -b ../sam/forward/chr${a}_P6.cmp.h5.bam.forward.bam -a ../mp_forward_10000/GQuadPlusFeatureOnly.mf.bed -counts >GQuadPlus.forward.depth.bed &

bedtools coverage -b ../sam/reverse/chr${a}_P6.cmp.h5.bam.reverse.bam -a ../mp_forward_10000/GQuadPlusFeatureOnly.mf.bed -counts >GQuadPlus.reverse.depth.bed &

#CONTROL
bedtools coverage -b ../sam/forward/chr${a}_P6.cmp.h5.bam.forward.bam -a ../mp_forward_10000_replicate1/GQuadPlusFeatureOnlyEmptyTmp.mf.bed -counts >GQuadPlusControl.forward.depth.bed &

bedtools coverage -b ../sam/reverse/chr${a}_P6.cmp.h5.bam.reverse.bam -a ../mp_forward_10000_replicate1/GQuadPlusFeatureOnlyEmptyTmp.mf.bed -counts >GQuadPlusControl.reverse.depth.bed &

wait

for d in G*depth; do
	grep "^${a}\b" ${d} | sort -k 1,1 -k2,2n >${a}.${d}
done

#sort mf files
f=GQuadPlusFeatureOnly.mfEmptyTmp.txt
grep "^${a}\b" ${f} | sort -k 1,1 -k2,2n >${a}.${f}

f=GQuadPlusFeatureOnly.mf
grep "^${a}\b" ${f} | sort -k 1,1 -k2,2n >${a}.${f}

echo "Done."

#MERGE TOGETHER
paste 1.GQuadPlusFeatureOnly.mf 1.GQuadPlus.forward.depth.bed >paste_GQuadPlus.forward
paste 1.GQuadPlusFeatureOnly.mf 1.GQuadPlus.reverse.depth.bed >paste_GQuadPlus.reverse