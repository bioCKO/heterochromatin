import sys
import os
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
#python parseAlignedFilesFillMatrix.py
######################################


alignedFile=sys.argv[1]
output=open((alignedFile+".txt"), 'w')

hits=["AAACATGGAAATATCTACACCGCTATCTCTAT","AAACATGGAAATATCTACACCGCTATCTGTAT","AAACATGGAAATATCTACACAGCCATCTGTAT","AAACATGGAAATATCTACACCGCCATCTGTAT"]
for i in hits:
    output.write(str(i) + " ")
    output.write("\n")

with open(alignedFile) as f:
    for line in f:
        line=line.rstrip()
        #print(line)
        if ("#" in line):
            array=line.split(" ")
            #print array[3:]
            lineOfMatrix=[0] * len(hits)
            for r in array[3:]:
                repeat=r.split(":")[0]
                count=r.split(":")[1]
                if repeat.upper() in hits: #check if uppercase string is in the list
                    #print("HIT")
                    index=hits.index(repeat.upper())
                    lineOfMatrix[index]=count
            #print ("lineOfMatrix: ")
            print(lineOfMatrix)
            for i in lineOfMatrix:
                output.write(str(i) + " ")
            output.write("\n")
    #print s, matches[s]
    #output.write(s + " " + str(matches[s]) + "\n")









