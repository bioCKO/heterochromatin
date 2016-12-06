import sys
import os
from os.path import basename
import subprocess as sp
import itertools
from itertools import izip
import math

######################################
#python generateFeatures.py motifFile
motifFile=str(sys.argv[1])
######################################
FeatureOnlyFile=motifFile.replace(".mf","FeatureOnly.mf")
print motifFile
print FeatureOnlyFile

f = open(FeatureOnlyFile, 'w') #write results here

#read motifFile and generate an output with features coordinates
with open(motifFile, "r") as ifile:
	for line in ifile:
		m=line.rstrip() #line from motif file

		m_array=m.split('\t')

		print (m_array[0:3])

		window_start=int(m_array[1])
		window_end=int(m_array[2])
		length=int(m_array[3])
		length=len(m_array)
		tail=m_array[3:length]

		print ("motif length: " + str(length))

		if (length % 2 == 0): #even 
			print "even"
			feature_start = window_start + 50 - math.trunc(length / 2) 
			feature_stop = window_start + 50 + math.trunc(length / 2) -1
		else: #odd
			print "odd"
			feature_start = window_start + 50 - trunc(length / 2)
			feature_stop = window_start + 50 + trunc(length / 2)
		res=(m_array[0] + "\t" + str(feature_start) + "\t" + str(feature_stop) + "\t" + '\t'.join(tail))
		print res
		f.write(res+"\n")
		print "***"
