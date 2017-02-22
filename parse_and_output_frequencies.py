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
			varType_and_depth=var.split('|')
			length=len(varType_and_depth)
			#print length
			if (length==1):
				print "no variants"
			else:
				varType=varType_and_depth[0]
				varDepth=varType_and_depth[1]
				#print varType
				if varType=="INS":
					INS[i]=float(varDepth)
				if varType=="DEL":
					DEL[i]=float(varDepth)
				if varType=="SNP":
					MISM[i]=float(varDepth)
		print ("INS"+str(INS))
		insertions=list(INS.values())
		insertions_mean_depth=np.array(insertions).mean()

		print ("DEL"+str(DEL))
		deletions=list(DEL.values())
		deletions_mean_depth=np.array(deletions).mean()
		
		print ("MISM"+str(MISM))
		mismatches=list(MISM.values())
		print mismatches
		mismatches_mean_depth=np.array(mismatches).mean()

		total=insertions+deletions+mismatches
		total_mean_depth=np.array(total).mean()

		perc_total=(len(total)/l)/total_mean_depth*100
		perc_ins=(len(insertions)/l)/insertions_mean_depth*100
		perc_del=(len(deletions)/l)/deletions_mean_depth*100
		perc_mism=(len(mismatches)/l)/mismatches_mean_depth*100

		if np.isnan(perc_total):
			perc_total=0
		if np.isnan(perc_ins):
			perc_ins=0
		if np.isnan(perc_del):
			perc_del=0
		if np.isnan(perc_mism):
			perc_mism=0

		#reference,start,end,totalRows,insertionRows,deletionRows,mismatchRows,percErrorTotal,percErrorIns,percErrorDel,percErrorMism,$$
		out=(chromosome + " " + str(start) + " " + str(end) + " " + str(l) + " " + str(len(total)) + " " + str(len(insertions)) + " " + str(len(deletions)) + " " + str(len(mismatches)) + " " + str(perc_total) + " " + str(perc_ins) + " " + str(perc_del) + " " + str(perc_mism) + " " +"$$\n")
		print(out)
		f.write(out)
		INS.clear()
		DEL.clear()
		MISM.clear()
		
