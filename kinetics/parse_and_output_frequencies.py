import sys
import os
from os.path import basename
import numpy as np

######################################
#python checkConsistency.py motifFile
motifFile=str(sys.argv[1])
minAF=float(sys.argv[2])
######################################
formattedFile=motifFile.replace(".collapsed","")

if "EmptyTmp" in formattedFile:
	formattedFile=formattedFile+(".txt")

print motifFile

f = open(formattedFile, 'w') #write results here

#read motifFile and generate an output that contains error percentages


INS={}
DEL={}
MISM={}

with open(motifFile, "r") as ifile:
	for line in ifile:
		print "---"
		print line
		i=0 #variant count
		m=line.rstrip() #line from motif file
		#print m
		m_array=m.split('\t')

		chromosome=m_array[0]
		start=float(m_array[1])
		end=float(m_array[2])
		l=float(end-start+1)

		v=m_array[3].replace('[', '').replace(']', '').replace('\'', '').replace(' ', '')
		variants=v.split(',')
		number_of_variants=len(variants)
		print ("number of variants: " + " " +str(number_of_variants))

		for var in variants:
			i=i+1
			varType_and_freq=var.split('|')
			length=len(varType_and_freq)
			#print length
			if (length==1):
				print "no variants"
			else:
				varType=varType_and_freq[0]
				varfreq=varType_and_freq[1]

				if (float(varfreq)>float(minAF)):
					print(str(varfreq) + " passed allele frequency threshold of " + str(minAF))
					if varType=="INS":
						INS[i]=float(varfreq)
					if varType=="DEL":
						DEL[i]=float(varfreq)
					if varType=="SNP":
						MISM[i]=float(varfreq)
		print ("INS"+str(INS))
		insertions=list(INS.values())
		print insertions
		insertions_mean_freq=np.nanmean(np.array(insertions))
		
		print ("DEL"+str(DEL))
		deletions=list(DEL.values())
		print deletions
		deletions_mean_freq=np.nanmean(np.array(deletions))

		print ("MISM"+str(MISM))
		mismatches=list(MISM.values())
		print mismatches
		mismatches_mean_freq=np.nanmean(np.array(mismatches))

		total=insertions + deletions + mismatches
		total_mean_freq=np.nanmean(np.array(total))

		perc_total=(len(total)/l)*total_mean_freq
		perc_insertions=(len(insertions)/l)*insertions_mean_freq
		perc_deletions=(len(deletions)/l)*deletions_mean_freq
		perc_mism=(len(mismatches)/l)*mismatches_mean_freq

		if np.isnan(perc_total):
			perc_total=0
		if np.isnan(perc_insertions):
			perc_insertions=0
		if np.isnan(perc_deletions):
			perc_deletions=0
		if np.isnan(perc_mism):
			perc_mism=0

		#reference,start,end,totalRows,insertionRows,deletionRows,mismatchRows,percErrorTotal,percErrorIns,percErrorDel,percErrorMism,$$
		out=(chromosome + " " + str(start) + " " + str(end) + " " + str(l) + " " + str(len(insertions)) + " " + str(len(deletions)) + " " + str(len(mismatches)) + " " + str(perc_total) + " " + str(perc_insertions) + " " + str(perc_deletions) + " " + str(perc_mism) + " " +"$$\n")
		print(out)
		f.write(out)
		INS.clear()
		DEL.clear()
		MISM.clear()
