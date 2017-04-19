import sys
import os
from os.path import basename
import itertools
from itertools import izip
import re
import collections
import pandas
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
    for line in f:
        line = line.rstrip()
        print line
        array = line.split('\t')
        chrom, start, end, molecule_frequencies = array[0], array[1], array[2],array[3]
        for molecule in molecule_frequencies.split(','):
            molecule_array=molecule.split(':')
            if len(molecule_array)==2:
                print(molecule_array)
                moleculeID,count = molecule_array[0], molecule_array[1]
                passesDict[moleculeID]+=int(count)

print("PASSES STATISTICS:")
#for w in sorted(passesDict, key=passesDict.get, reverse=True):
#  print w, passesDict[w]

counts = values(passesDict).value_counts()
print counts
