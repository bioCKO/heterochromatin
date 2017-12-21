#!/usr/bin/env python

import sys
import os
import re
import collections
import os.path
import itertools
import operator

from os.path import basename
from itertools import izip
from collections import defaultdict


######################################
#python paste.py lengths summary
lengths=str(sys.argv[1])
summary=str(sys.argv[2])
######################################

print("lengths: " + lengths + "; " + "summary: " + summary)

outputEmpty=("paste." + summary)

# Do not overwrite existing file
if (os.path.exists(outputEmpty)):
    print("File " + outputEmpty + " already exists. Quit.")
    sys.exit()

fout = open(outputEmpty, 'w')

with open(lengths) as textfile1, open(summary) as textfile2: 
    for x, y in izip(textfile1, textfile2):
        x = x.strip()
        #print("----")
        #print (x)
        #print(y)
        array_with_coverage=y.rstrip().split("\t")
        left = array_with_coverage[0:3]
        right = array_with_coverage[4:] #skip third column
        output=('\t'.join(left) + "\t" + x + "\t" + '\t'.join(right))
        #print (output)
        fout.write(output + '\n')

fout.close()


