import sys
import os
from os.path import basename
import numpy as np
import itertools
from itertools import izip

######################################
#python merge_files.py errFile1 errFile2 ... errFileN
######################################

file_list=sys.argv[1:]

files = [open(i, "r") for i in file_list]
for rows in izip(*files):
	sys.stdout.write(max(rows, key=len)) #print the rows from the file that has the longest list -> has PacBio information