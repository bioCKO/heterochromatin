export PATH="/nfs/brubeck.bx.psu.edu/scratch5/wilfried/src/samtools-1.3.1:$PATH"
export PATH="/nfs/brubeck.bx.psu.edu/scratch5/wilfried/src/bedtools2-master/bin:$PATH"

a=1; #chromosome 1 

#FEATURE
bedtools coverage -abam ../sam/forward/chr${a}_P6.cmp.h5.bam.forward.bam -b ../mp_forward_10000/GQuadPlusFeatureOnly.mf.bed -counts >${a}.GQuadPlus.forward.depth &

bedtools coverage -abam ../sam/reverse/chr${a}_P6.cmp.h5.bam.reverse.bam -b ../mp_forward_10000/GQuadPlusFeatureOnly.mf.bed -counts >${a}.GQuadPlus.reverse.depth &

#CONTROL
bedtools coverage -abam ../sam/forward/chr${a}_P6.cmp.h5.bam.forward.bam -b ../mp_forward_10000_replicate1/GQuadPlusFeatureOnlyEmptyTmp.mf.bed -counts >${a}.GQuadPlusControl.forward.depth &

bedtools coverage -abam ../sam/reverse/chr${a}_P6.cmp.h5.bam.reverse.bam -b ../mp_forward_10000_replicate1/GQuadPlusFeatureOnlyEmptyTmp.mf.bed -counts >${a}.GQuadPlusControl.reverse.depth &

wait

echo "Done."