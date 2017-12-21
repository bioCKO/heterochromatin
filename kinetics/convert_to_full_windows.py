import sys
import os
from os.path import basename
import subprocess as sp
import itertools
from itertools import izip
import math

######################################
#python convert_to_full_windows.py emptyFile
emptyFile=str(sys.argv[1])
######################################

print emptyFile

outputEmpty=emptyFile.replace("FeatureOnly","FullWindow")
f = open(outputEmpty, 'w') #write results here

#read EmptyTmp file restricted to windows and output full windows
with open(emptyFile, "r") as efile:
	for line in efile:
		#print(line)
		e=line.rstrip() #line from matched empty file
		e_array=e.split('\t')
		#print (e_array[0:3])

		window_start=int(e_array[1]) #coordinates from empty file
		window_end=int(e_array[2]) #coordinates from empty file

		#print("window_start: " + str(window_start) + " window_end: " + str(window_end))

		length=int(e_array[3]) #length from motif file
		tail=e_array[4:len(e_array)]
			#print ("tail: " + str(tail))

		#print ("motif length: " + str(length))
		bp_to_fill=100-length
		#print ("bp_to_fill: " + str(bp_to_fill))

		if (length % 2 == 0): #even 
			print "even"
			window_start = window_start - (math.trunc(bp_to_fill / 2))
			window_end = window_end + (math.trunc(bp_to_fill / 2))
			#IPDsubset = tail[(50 - math.trunc(length / 2)):(50 + math.trunc(length / 2))]
		else: #odd
			print "odd"
			window_start = window_start - (math.trunc(bp_to_fill / 2)+1)
			window_end = window_end + (math.trunc(bp_to_fill / 2))
			#IPDsubset = tail[(50 - math.trunc(length / 2)):(50 + math.trunc(length / 2) + 1)] #center is 51st nucleotide

		#print("window_start: " + str(window_start) + " window_end: " + str(window_end))
		#print(str(window_end-window_start+1))
		res=(e_array[0] + "\t" + str(window_start) + "\t" + str(window_end) + "\t" + str(length)) #+ "\t" + '\t'.join(IPDsubset))
		print res
		f.write(res+"\n")
		#print "***"



