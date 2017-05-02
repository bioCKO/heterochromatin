import sys
import os
from os.path import basename
import itertools
from itertools import izip
import re
import collections
from collections import defaultdict


######################################
#python reorder.py motifFileWithIPds motifFileWithErrors
motifFileWithIPds=str(sys.argv[1])
motifFileWithErrors=str(sys.argv[2])
######################################

#print motifFile
errorDict=defaultdict(int)

#outputEmpty=motifFile + "_formatted.txt"
#f = open(outputEmpty, 'w') #write results here

def formatWhitespaces(text):
	text=text.rstrip() #remove newline
	text=re.sub(' +',' ',text) #remove multiple whitespaces
	text=re.sub('^ ','',text) #remove leading whitespace
	return text

with open(motifFileWithErrors) as f:
    for line in f:
        array=line.rstrip().replace("\t", " ").split(" ") #replace tabs by spaces and split
        #print array
        key=str(array[0:3])
        values=array[3:]
        errorDict[key]=values
f.close()

print("printing dictionary")
for k in errorDict.keys():
	print k, errorDict[k]

print("parse motifFileWithIPds")

with open(motifFileWithIPds) as f:
    for line in f:
        array=line.rstrip().replace("\t", " ").split(" ") #replace tabs by spaces and split
        print ("array")
        print(array)
        key=array[0:3]
        values=errorDict[str(key)]
        merged=key+values
        merged=reduce(lambda key, values: key+" "+values, merged)
        print ("dictionary")
        print(merged)

