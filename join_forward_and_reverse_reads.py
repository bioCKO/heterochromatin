import sys
import os
from os.path import basename
import numpy as np
import collections
import subprocess
from Bio import SeqIO
from Bio.Seq import Seq
from collections import deque
from collections import defaultdict

######################################
#python join_forward_and_reverse_reads.py forwardReads reverseReads
######################################


forward=sys.argv[1]
reverse=sys.argv[2]

f = open(forward)
r = open(reverse)

fDict=collections.OrderedDict()
rDict=collections.OrderedDict()
matches=defaultdict(int)
fList=[]
rList=[]

with open(forward) as f:
    i=0
    next(f)
    previousHeader=""
    for line in f:
        line=line.rstrip()
        i=i+1
        if ("@" in line):
            header=previousHeader
            previousHeader=line
            if (i>1):
                #store results to previous header
                fDict[header]=fList
                fList=[]
        else:
            fList.append(line)
    fDict[previousHeader]=fList #last entry
print("#reads containg forward repeats:" + str(len(fDict.keys())))

with open(reverse) as r:
    i=0
    next(r)
    previousHeader=""
    for line in r:
        line=line.rstrip()
        i=i+1
        if ("@" in line):
            header=previousHeader
            previousHeader=line
            if (i>1):
                #store results to previous header
                rDict[header]=rList
                rList=[]
        else:
            rList.append(line)
    rDict[previousHeader]=rList #last entry
print("#reads containg reverse repeats:" + str(len(rDict.keys())))

#find intersections
keys_f = set(fDict.keys())
keys_r = set(rDict.keys())
intersection = keys_f & keys_r # '&' operator is used for set intersection

print("reads with both sides containing repeats" + str(intersection))

for i in intersection:
    print i
    repeatF=fDict[i] #list of forward repeats
    repeatR=rDict[i] #list of reverse repeats

    print(repeatF)
    print(repeatR)
    for f in repeatF:
        for r in repeatR:
            first=f.split(" ")[2]
            second=r.split(" ")[2]
            if (first==second):
                print("match")
                matches[first]+=1
print matches













