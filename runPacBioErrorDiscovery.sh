set -e
#set -x
export PATH="/nfs/brubeck.bx.psu.edu/scratch5/wilfried/src/samtools-1.3.1:$PATH"
export PATH="/nfs/brubeck.bx.psu.edu/scratch5/wilfried/src/bedtools2-master/bin:$PATH"

###############################
#PACBIO GENERATE ERROR PROFILES
###############################

#FORWARD
./generate_mpileup.sh /nfs/brubeck.bx.psu.edu/scratch6/monika/pac_errors/passes/forward /nfs/brubeck.bx.psu.edu/scratch6/monika/pac_errors/passes/sam/forward /nfs/brubeck.bx.psu.edu/scratch6/monika/pac_errors/passes/mp_forward

./format_mpileup.sh /nfs/brubeck.bx.psu.edu/scratch6/monika/pac_errors/passes/forward /nfs/brubeck.bx.psu.edu/scratch6/monika/pac_errors/passes/mp_forward /nfs/brubeck.bx.psu.edu/scratch6/monika/pac_errors/passes/mp_forward

#REVERSE
./generate_mpileup.sh /nfs/brubeck.bx.psu.edu/scratch6/monika/pac_errors/passes/reverse /nfs/brubeck.bx.psu.edu/scratch6/monika/pac_errors/passes/sam/reverse /nfs/brubeck.bx.psu.edu/scratch6/monika/pac_errors/passes/mp_reverse

./format_mpileup.sh /nfs/brubeck.bx.psu.edu/scratch6/monika/pac_errors/passes/reverse /nfs/brubeck.bx.psu.edu/scratch6/monika/pac_errors/passes/mp_reverse /nfs/brubeck.bx.psu.edu/scratch6/monika/pac_errors/passes/mp_reverse