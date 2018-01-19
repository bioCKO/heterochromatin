#!/bin/bash
#SBATCH -C new
#SBATCH --nodes=1
#SBATCH --ntasks=2
#SBATCH -t 0

set -e
set -x

#create folders for results if they don't exist already
mkdir -p joint_stat

forward=$1
reverse=$2

python giveJointStatForRepeat.py $forward $reverse 75 joint_stat

echo "Done."