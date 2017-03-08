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
reverse=sys.argv[2]

fRepeats=[]
rRepeats=[]

f = open(forward)
r = open(reverse)
print(f.readline())
print(r.readline())

#print("lineR: " + lineR)
headerF=f.readline().rstrip()
lineR=r.readline().rstrip()
isHeader=True
while True:
    Fnumber=headerF.split(".")[1]
    print("headerF: " + headerF + " " + Fnumber)
    if ("@" in headerF):
        #if (headerF==lineR):
        #print(isHeader)
        last_pos = r.tell()
        while (isHeader==False):
            lineR=r.readline().rstrip()
            isHeader=("@" in lineR)
            #print("isHeader: " + str(isHeader) + " lineR: " + str(lineR))
            #Rnumber=lineR.split(".")[1]
            #print("lineR: " + lineR + " " + Rnumber)
        #r.seek(last_pos)
        print("checking for match" + headerF + " and " + lineR)
        isHeader=False #now we need to iterate again through reverse reads
        #print("headerF: " + headerF + " " + Fnumber)
        Fnumber=int(headerF.split(".")[1])
        Rnumber=int(lineR.split(".")[1])
        if (headerF==lineR):
            print "Match, read next forward header."
            isFHeader=False
            while (isFHeader==False):
                headerF=f.readline().rstrip()
                isFHeader=("@" in headerF)
                #print("isFHeader: " + str(isFHeader))
            print("We found new forward header: " + headerF)
        if (Rnumber>Fnumber):
            print("Forward has no repeats, we need to read next forward, while keeping old reverse.")
            r.seek(last_pos) #keep old reverse
            isFHeader=False
            while (isFHeader==False):
                headerF=f.readline().rstrip()
                isFHeader=("@" in headerF)
                #print("isFHeader: " + str(isFHeader))
            print("We found new forward header: " + headerF)

#r.seek(last_pos)