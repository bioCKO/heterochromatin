import sys
import os
from os.path import basename
import numpy as np
import itertools
from itertools import izip

######################################
#python join_forward_and_reverse_reads.py forwardReads reverseReads
######################################

forward=sys.argv[1]
reverse=sys.argv[1]

fRepeats=[]
rRepeats=[]

f = open(forward)
r = open(reverse)
print(f.readline())
lineR=r.readline()
print("lineR: " + lineR)
while True:
    headerF=f.readline()
    print("headerF: " + headerF)
    if ("@" in headerF):
        if (headerF==lineR):
            last_pos = r.tell()
            isHeader=("@" not in lineR)
            print(isHeader)
            while (isHeader==False):
                lineR=r.readline()
                print("lineR: " + lineR)
            print("match")
#r.seek(last_pos)