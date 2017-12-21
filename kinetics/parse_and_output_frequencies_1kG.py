import sys
import os
from os.path import basename
import numpy as np

######################################
#python checkConsistency.py motifFile
motifFile=str(sys.argv[1])
######################################
formattedFile=motifFile.replace(".collapsed","")

print motifFile

f = open(formattedFile, 'w') #write results here

#read motifFile and generate an output that contains error percentages


INDEL={}
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
				#print varType
				if varType=="INDEL":
					INDEL[i]=float(varfreq)
				if varType=="SNP":
					MISM[i]=float(varfreq)
		print ("INDEL"+str(INDEL))
		indels=list(INDEL.values())
		print indels
		indels_mean_freq=np.array(indels).mean()
		
		print ("MISM"+str(MISM))
		mismatches=list(MISM.values())
		print mismatches
		mismatches_mean_freq=np.array(mismatches).mean()

		total=indels+mismatches
		total_mean_freq=np.array(total).mean()

		perc_total=(len(total)/l)*total_mean_freq
		perc_indels=(len(indels)/l)*indels_mean_freq
		perc_mism=(len(mismatches)/l)*mismatches_mean_freq

		if np.isnan(perc_total):
			perc_total=0
		if np.isnan(perc_indels):
			perc_indels=0
		if np.isnan(perc_mism):
			perc_mism=0

		#reference,start,end,totalRows,insertionRows,deletionRows,mismatchRows,percErrorTotal,percErrorIns,percErrorDel,percErrorMism,$$
		out=(chromosome + " " + str(start) + " " + str(end) + " " + str(l) + " " + str(len(indels)) + " " + str(len(indels)) + " " + str(len(mismatches)) + " " + str(perc_total) + " " + str(perc_indels) + " " + str(perc_indels) + " " + str(perc_mism) + " " +"$$\n")
		print(out)
		f.write(out)
		INDEL.clear()
		MISM.clear()
		
