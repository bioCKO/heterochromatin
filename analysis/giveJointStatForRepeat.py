import sys
import os
import argparse
from os.path import basename
import numpy as np
import collections
import subprocess
import operator
from Bio import SeqIO
from Bio.Seq import Seq
from collections import deque
from collections import defaultdict
from sets import Set

######################################
#python join_forward_and_reverse_reads.py forwardReads reverseReads
######################################

parser = argparse.ArgumentParser()
parser.add_argument("forward")
parser.add_argument("reverse")
parser.add_argument('bp_threshold', help='number of repeat bp required', type=int)

args = parser.parse_args()

forward=args.forward
reverse=args.reverse
threshold=args.bp_threshold

if (os.path.isfile(forward)!=True):
    print("File " + forward + " does not exist. No joining can be performed.")
    sys.exit()

if (os.path.isfile(reverse)!=True):
    print("File " + reverse + " does not exist. No joining can be performed.")
    sys.exit()

f = open(forward)
r = open(reverse)

output_name=(forward+"joinedRepeatFreq.txt")
# Do not overwrite existing file
#if (os.path.exists(output_name)):
#    print("File " + output_name + " already exists. Quit.")
#    sys.exit()

output=open(output_name, 'w')

fDict=collections.OrderedDict()
rDict=collections.OrderedDict()
joint_matches=defaultdict(int)
fList=[]
rList=[]

def getNumberOfValidRepeats(motif,myDict):
    motifCount=0
    for array in myDict.values():
        for i in array:
            if (i):
                r=i.split(" ")[2]
                l=int(i.split(" ")[6])
                if (r==motif and l>=threshold):
                    #print(str(i) + " " + str(r) + " " + str(l))
                    motifCount+=1
    return(motifCount)


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
print("#forwardReads:" + str(len(fDict.keys())))

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
print("#reverseReads:" + str(len(rDict.keys())))

#print(fDict)
#print(rDict)

intersection = set(fDict.keys()) & set(rDict.keys()) # '&' operator is used for set intersection
print("#same header in both forward and reverse reads:" + str(len(intersection))) #this will be situation when both reads in a pair survived filtering

for i in intersection:
    #print i
    repeatF=fDict[i] #list of forward repeats
    repeatR=rDict[i] #list of reverse repeats

    for f in repeatF:
        first=f.split(" ")[2]
        for r in repeatR:
            second=r.split(" ")[2]
    
            first_length=int(f.split(" ")[6])
            second_length=int(r.split(" ")[6])

            if (first==second): #repeat motif matches
                #print("match")
                #['1 100 AAACATGGAAATACCTACACCGCTATCTCTAT AAATACCTACACCGCTATCTCTATAAACATGG 32 3.1 100']

                #only count if repeats in both reads are over threshold
                if ((first_length>=threshold) and (second_length>=threshold)):
                    #print(str(first) + " first_length " + str(first_length) + " " + str(second) + " second_length " + str(second_length))
                    joint_matches[first]+=1

#print joint_matches

output.write("repeat joint_count forward_count reverse_count tandemness_fraction\n") #print header

sorted_keys = sorted(joint_matches, key=joint_matches.get, reverse=True)
for s in sorted_keys:
    print s, joint_matches[s]
    repeatOnForwardStrand=getNumberOfValidRepeats(s,fDict)
    repeatOnReverseStrand=getNumberOfValidRepeats(s,rDict)
    fraction=(int(joint_matches[s])*2)/float(repeatOnForwardStrand+repeatOnReverseStrand)
    fraction=round(fraction*100,2)
    output.write(s + " " + str(joint_matches[s]) + " " + str(repeatOnForwardStrand) + " " + str(repeatOnReverseStrand) + " " + str(fraction) + "\n")
    sys.stdout.flush()

    print(str(s) + " repeat on forward strand: " + str(repeatOnForwardStrand))
    print(str(s) + " repeat on reverse strand: " + str(repeatOnReverseStrand))



