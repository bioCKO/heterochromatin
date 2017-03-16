#!/usr/local/bin/python
# parses text file and outputs lexicographically smallest representative
import sys
import test
import os
import re
import subprocess
from Bio import SeqIO
from Bio.Seq import Seq
from collections import deque

def RotateMe(text,mode=0,steps=1):
    # function from http://www.how2code.co.uk/2014/05/how-to-rotate-the-characters-in-a-text-string/
    # Takes a text string and rotates
    # the characters by the number of steps.
    # mode=0 rotate right
    # mode=1 rotate left
    length=len(text)
     
    for step in range(steps):
    # repeat for required steps
        if mode==0:
            # rotate right
            text=text[length-1] + text[0:length-1]
        else:
            # rotate left
            text=text[1:length] + text[0]
    return text

def SmallestRotation(seq):
    smallest=seq
    for i in range(0,len(seq)):
        actual=RotateMe(seq,0,i)
        #print ("*" + actual)
        if (actual<smallest):
            #found new minimum
            smallest=actual
    return smallest

def lexicographicallySmallestRotation(seq):
    my_seq=Seq(seq)
    reverse_complement=my_seq.reverse_complement()
    reverse_complement=str(reverse_complement)

    smrt_seq=SmallestRotation(seq)
    smrt_rev_compl_seq=SmallestRotation(reverse_complement)

    #lexicographically smallest rotation is either one of the rotations of the sequence or its reverse complement
    if (smrt_seq < smrt_rev_compl_seq):
        return smrt_seq
    else:
        return smrt_rev_compl_seq

def parseTRF(file):
    i=0
    for line in open(file):
        array=(line.strip()).split("\t")
        f.write(lexicographicallySmallestRotation(array[0]) + "\t" + str(len(array[1])) + "\t" + array[0] + "\n") #analyze repeats from the previous sequence
        i=i+1
        if (i%100==0):
            print("processing repeat on line " + str(i))
            f.flush() #empty write buffer
    return str(i)
                    
repeat_file = sys.argv[1]
f = open(repeat_file + ".rep","w")
print ("Repeat processing done, " + parseTRF(repeat_file) + " repeats written to file " + repeat_file + ".rep")
f.close()



