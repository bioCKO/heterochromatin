export PATH="/nfs/brubeck.bx.psu.edu/scratch5/wilfried/src/samtools-1.3.1:$PATH"
export PATH="/nfs/brubeck.bx.psu.edu/scratch5/wilfried/src/bedtools2-master/bin:$PATH"

a=1; #chromosome 1 

#FEATURE
bedtools coverage -b ../sam/forward/chr${a}_P6.cmp.h5.bam.forward.bam -a ../mp_forward_10000/GQuadPlusFeatureOnly.mf.bed -counts >GQuadPlus.forward.depth &

bedtools coverage -b ../sam/reverse/chr${a}_P6.cmp.h5.bam.reverse.bam -a ../mp_forward_10000/GQuadPlusFeatureOnly.mf.bed -counts >GQuadPlus.reverse.depth &

#CONTROL
bedtools coverage -b ../sam/forward/chr${a}_P6.cmp.h5.bam.forward.bam -a ../mp_forward_10000_replicate1/GQuadPlusFeatureOnlyEmptyTmp.mf.bed -counts >GQuadPlusControl.forward.depth &

bedtools coverage -b ../sam/reverse/chr${a}_P6.cmp.h5.bam.reverse.bam -a ../mp_forward_10000_replicate1/GQuadPlusFeatureOnlyEmptyTmp.mf.bed -counts >GQuadPlusControl.reverse.depth &

wait

for d in *depth; do
	grep "^{a}\b" $d >${a}.${d}
done
echo "Done."