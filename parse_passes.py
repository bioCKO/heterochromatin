import sys
import os
from os.path import basename
import itertools
from itertools import izip
import re
import collections
from collections import defaultdict
#for a in xx*; do head -n 3 $a | tail -n 1 | cut -d' ' -f2 | sed 's/"//g'; python parse_passes.py $a; done;

######################################
#python generateEmptyTrack.py motifFile
motifFile=str(sys.argv[1])
######################################

#print motifFile
passesDict=defaultdict(int)

#outputEmpty=motifFile + "_formatted.txt"
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
        #print("***")
        coordinates=formatWhitespaces(coordinates)
        passes=formatWhitespaces(passes).split(" ")
        counts=formatWhitespaces(counts).split(" ")
        #print(coordinates,space,passes,counts)

        for i in range(0, len(passes), 1):
        	p=passes[i]
        	c=counts[i]
        	#print("p:" + p + " c:" + c)
        	passesDict[p]+=int(c)


for k in passesDict.keys():
	print k, passesDict[k]
