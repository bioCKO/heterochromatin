import sys
import os
from os.path import basename
import itertools
from itertools import izip
import re
import collections
import pandas as pd
from collections import defaultdict
#for a in xx*; do head -n 3 $a | tail -n 1 | cut -d' ' -f2 | sed 's/"//g'; python parse_passes.py $a; done;

######################################
#python generateEmptyTrack.py motifFile
motifFile=str(sys.argv[1])
######################################

try:
    minNumberOfPasses=int(sys.argv[2])
except Exception:
    print "Error when reading integer for minNumberOfPasses."
    sys.exit()

try:
    maxNumberOfPasses=int(sys.argv[3])
except Exception:
    print "Error when reading integer for maxNumberOfPasses."
    sys.exit()

#print motifFile
passesDict=defaultdict(int)

#outputEmpty=motifFile + "_formatted.txt"
#f = open(outputEmpty, 'w') #write results here

def formatWhitespaces(text):
	text=text.rstrip() #remove newline
	text=re.sub(' +',' ',text) #remove multiple whitespaces
	text=re.sub('^ ','',text) #remove leading whitespace
	return text

print ("chrom start end moleculeID passes")
with open(motifFile) as f:
    for line in f:
        line = line.rstrip()
        #print line
        array = line.split('\t')
        chrom, start, end, molecule_frequencies = array[0], array[1], array[2],array[3]
        for molecule in molecule_frequencies.split(','):
            molecule_array=molecule.split(':')
            if len(molecule_array)==2:
                #print(molecule_array)
                moleculeID,count = molecule_array[0], molecule_array[1]
                count=int(count)
                if moleculeID in passesDict: #already in dictionary, will keep higher number of passes
                    actual_number_of_passes=passesDict[moleculeID]
                    if (count>actual_number_of_passes):
                        passesDict[moleculeID]=count
                else:
                    passesDict[moleculeID]=count
                #does the molecule have sufficient number of passes?
                if ((int(count) >= int(minNumberOfPasses)) & (int(count) <= int(maxNumberOfPasses))):
                    print (chrom + " " + start + " " + end + " " + moleculeID + " " + str(count))


print("PASSES STATISTICS:")
#for w in sorted(passesDict, key=passesDict.get, reverse=True):
#  print w, passesDict[w]

#for i in passesDict:
#    print i, passesDict[i]

counts = pd.value_counts(passesDict)

ordered = dict(counts)

for k, v in ordered.iteritems(): print k, v
