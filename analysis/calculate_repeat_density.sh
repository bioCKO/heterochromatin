declare -a species_array=("Bonobo06" "BorneanOrangutan01" "Chimpanzee03" "Gorilla02" "Human05" "SumatranOrangutan04")
declare -a species_array=("Bonobo06")


#!/bin/sh

return_total_bps_in_sample()
{
  species=$1

  if [ "$species" = "Human05" ]; then
    echo 395873031
  fi

  if [ "$species" = "Chimpanzee03" ]; then
    echo 55129295
  fi

  if [ "$species" = "Bonobo06" ]; then
    echo 667206307
  fi

  if [ "$species" = "Gorilla02" ]; then
    echo 526038322
  fi

  if [ "$species" = "SumatranOrangutan04" ]; then
    echo 614889481
  fi

  if [ "$species" = "BorneanOrangutan01" ]; then
    echo 383238785
  fi

}

for species in "${species_array[@]}"
do
	start=1
	end=39
	for ((i=start; i<=end; i++))
	do
		echo  ""
		echo "i: $i"
		inputFile=${species}.fasta.rep${i}.stats
		echo `ls ${inputFile}`
		repeat_bps=`cat ${inputFile} | grep -v "#" | cut -f8 | awk '{s+=$1} END {print s}'`
		if [ -z ${repeat_bps} ]; then echo "repeat_bps is unset, set to 0"; repeat_bps=0; else echo "repeat_bps is set to '$repeat_bps'"; fi
		read_bps=`return_total_bps_in_sample ${species}`
		echo "total bps per species is " ${read_bps}
		#read_bps=`cat ${species}.fasta.rep${i}.stats | grep -v "#" | cut -f7 | awk '{s+=$1} END {print s}'` #this is from the reads that contain repeats
		repeat_density=`echo ${repeat_bps} ${read_bps}| awk '{ print $1/$2*1000000 }'`
		echo "calculated repeat density: " ${repeat_density}
		echo ${repeat_density} >${species}.${i}.density
	done
done

