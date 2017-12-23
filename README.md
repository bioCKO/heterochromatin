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

* 1) ####Download the files and name them accordingly
	scripts: download_run.sh and rename.py
	
*Input*: SRR run id

*Output*: fastq file

*Requirements*: sratoolkit.2.5.7-ubuntu64/bin/fastq-dump

* 2) ####Identify the repeats 
	scripts: analyze_raw_fastq.sh, parseTRFngsKeepHeader.py
	
*Input*: fastq file

*Output*: .dat and .dat_Header.txt

*Requirements*: fastx, seqtk, trf409.legacylinux64 

* 2) ####Identify the repeats 
	scripts:  run_jobs.sh, analyze_raw_fastq.sh, parseTRFngsKeepHeader.py
	
*Input*: fastq file

*Output*: .dat and .dat_Header.txt

*Requirements*: fastx, seqtk, trf409.legacylinux64 

* 3) ####Parse repeats into repeat frequency (.rawcounts) and repeat density (.rawlengths)
	scripts: parse_headers.sh
	
*Input*: .dat_Header.txt

*Output*: .rawcounts and .rawlengths

*Requirements*: none

* 4) ####Filter repeat motifs based on minimum frequency
	scripts: filter_raw_files.sh
	
*Input*: .rawcounts (automatically processes also .rawlengths)

*Output*: .rawcounts.sortedFilt and .rawlengths.sortedFilt

*Requirements*: none

* 5) ####Merge identified repeat motifs into single table
	scripts: run_merging.sh
	
*Input*: rawcounts.sortedFilt or rawlengths.sortedFilt

*Output*: big.table.with.header.rawcounts.sortedFilt.txt and big.table.with.header.rawlengths.sortedFilt.txt

*Requirements*: none

* 6) ####Load the table into R and do more filtering
	scripts: loadAndSaveData.Rnw
	
*Input*: big.table.with.header.rawcounts.sortedFilt.txt and big.table.with.header.rawlengths.sortedFilt.txt

*Output*: R variables frequency and density


### Who do I talk to? ###

biomonika@psu.edu