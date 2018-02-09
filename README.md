# README #

This README accompanies paper "Turnover of heterochromatin-associated repeats in great apes: Species and sex differences".

### What is this repository for? ###

* The pipeline for the identification and analysis of repeats in great apes.
* 1.0
* [Learn Markdown](https://bitbucket.org/tutorials/markdowndemo)

### How do I get set up? ###

R libraries needed:

* require(data.table)
* require(plyr)
* require(dplyr)
* require(dendextend)
* require(reshape)
* require(hexbin)
* require(gplots)
* require(e1071)
* require(rgl)
* require(ggfortify)
* require(dendextend)
* require(fmsb)
* require(grDevices)
* require(lattice)
* require(randomcoloR)
* require(corrr)
* require(robustbase)
* require(ICC)
* require(VennDiagram)
* library(VennDiagram)
* source("http://www.sthda.com/upload/rquery_cormat.r")

### Pipeline ###

####1. Download the files and name them accordingly
	scripts: download_run.sh and rename.py
	
*Input*: SRR run id

*Output*: fastq file

*Requirements*: sratoolkit.2.5.7-ubuntu64/bin/fastq-dump

####2. Identify the repeats 
	scripts:  run_jobs.sh, analyze_raw_fastq.sh, parseTRFngsKeepHeader.py
	
*Input*: fastq file

*Output*: .dat and .dat_Header.txt

*Requirements*: fastx, seqtk, trf409.legacylinux64 

####3. Filter repeat arrays shorter than 75bps and parse repeats into repeat frequency (.rawcounts) and repeat density (.rawlengths)
	scripts: parse_headers.sh
	
*Input*: .dat_Header.txt

*Output*: .rawcounts and .rawlengths

*Requirements*: none

Use datasets trimmed to 100bp reads if available.

####4. Filter repeat motifs based on minimum frequency
	scripts: filter_raw_files.sh
	
	for file in *.rawcounts; do echo $file; sbatch filter_raw_files.sh $file; sleep 0.1; done;
	
*Input*: .rawcounts (automatically processes also .rawlengths)

*Output*: .rawcounts.sortedFilt and .rawlengths.sortedFilt

*Requirements*: none

####5. Merge identified repeat motifs into single table
	scripts: run_merging.sh
	 ./run_merging.sh rawcounts.sortedFilt; ./run_merging.sh rawlengths.sortedFilt;
	
*Input*: rawcounts.sortedFilt or rawlengths.sortedFilt

*Output*: big.table.with.header.rawcounts.sortedFilt.txt and big.table.with.header.rawlengths.sortedFilt.txt

*Requirements*: none

####6. Load the table into R and do more filtering
Filters: the cummulative repeat frequency per million reads needs to be at least 15 across all datasets
	scripts: loadAndSaveData.Rnw
	
*Input*: big.table.with.header.rawcounts.sortedFilt.txt and big.table.with.header.rawlengths.sortedFilt.txt

*Output*: R variables frequency and density

### Additional analysis ###

####Analysis of tandemness
	scripts: calculateJointStat.sh, giveJointStatForRepeat.py and analyze_tandemness.sh
	
	for a in *1.fastq.dat_Header.txt; do echo $a; b=`echo $a | sed s'/1.fastq/2.fastq/g'`; echo $b; sbatch calculateJointStat.sh ${a} ${b}; sleep 0.1; done; 
	
*Input*: .dat_Header.txt

*Output*: .joinedRepeatFreq.txt


### Who do I talk to? ###

biomonika@psu.edu