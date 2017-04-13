import sys
import os
from os.path import basename
import subprocess as sp
import itertools
from itertools import izip
import re
import collections
from collections import defaultdict

######################################
#python generateEmptyTrack.py motifFile
motifFile=str(sys.argv[1])
######################################

print motifFile
passesDict=defaultdict(int)

outputEmpty=motifFile + "_formatted.txt"

#f = open(outputEmpty, 'w') #write results here
def formatWhitespaces(text):
	text=text.rstrip() #remove newline
	text=re.sub(' +',' ',text) #remove multiple whitespaces
	text=re.sub('^ ','',text) #remove leading whitespace
	return text

with open(motifFile) as f:
    f.readline() #skip header
    f.readline() #skip header
    f.readline() #skip header
    for coordinates,space,passes,counts in itertools.izip_longest(*[f]*4):
        print("***")
        coordinates=formatWhitespaces(coordinates)
        passes=formatWhitespaces(passes).split(" ")
        counts=formatWhitespaces(counts).split(" ")
        print(coordinates,space,passes,counts)

        for i in range(0, len(passes), 1):
        	p=passes[i]
        	c=counts[i]
        	print("p:" + p + " c:" + c)
        	passesDict[p]+=int(c)

print passesDict
#with open(motifFile) as f:
#    for line in f:
    	#if line.strip():
#    		line=line.rstrip() #remove newline
#    		line=re.sub(' +',' ',line) #remove multiple whitespaces
#    		line=re.sub('^ ','',line) #remove leading whitespace
#        	if ("[" not in line): #we are not interested in coordinates
#        		print line
#        		#keys=line
	#f.write(res+"\n")
	#print "***"