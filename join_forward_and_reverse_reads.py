import sys
import os
from os.path import basename
import numpy as np
import collections

######################################
#python join_forward_and_reverse_reads.py forwardReads reverseReads
######################################

forward=sys.argv[1]
reverse=sys.argv[2]

f = open(forward)
r = open(reverse)

fDict=collections.OrderedDict()
rDict=collections.OrderedDict()
fList=[]

with open(forward) as f:
    i=0
    for line in f:
        line=line.rstrip()
        i=i+1
        if ("@" in line):
            header=line
            if (i>1):
                #store results to previous header
                fDict[header]=fList
                fList=[]
        else:
            fList.append(line)
    fDict[header]=fList #last entry
print(fDict)
