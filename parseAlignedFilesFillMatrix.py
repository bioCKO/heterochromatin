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
matrix=[[]]

i=0
with open(alignedFile) as f:
    for line in f:
        i=i+1
        line=line.rstrip()
        if ("#" in line):
            array=line.split(" ")
            print array[3:]
            for r in array[3:]:
                repeat=r.split(":")[0]
                count=r.split(":")[1]
                print count
                print repeat
                if repeat in hits:
                    print hits.index(element)
       
    #print s, matches[s]
    #output.write(s + " " + str(matches[s]) + "\n")









