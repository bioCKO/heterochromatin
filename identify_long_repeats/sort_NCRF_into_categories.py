#!/usr/bin/env python3
import os, errno

import argparse
parser = argparse.ArgumentParser()                                               

parser.add_argument("--file", "-f", type=str, required=True)
args = parser.parse_args()

filepath = args.file
filename = os.path.basename(filepath)
print(filename)

topdir = os.getcwd() #current directory

try:
    os.makedirs(topdir + '/' + 'nested')
    os.makedirs(topdir + '/' + 'marginal')
    os.makedirs(topdir + '/' + 'heterochromatic')
except OSError as e:
    if e.errno != errno.EEXIST:
        raise


nested_file = open(topdir + '/' + 'nested' + '/' + filename,'w')
marginal_file = open(topdir + '/' + 'marginal' + '/' + filename,'w')
heterochromatic_file = open(topdir + '/' + 'heterochromatic' + '/' + filename,'w')

with open(filepath) as fp:  
   line = fp.readline()
   cnt = 1
   while line:
       #print("Line {}: {}".format(cnt, line.strip()))

       if (cnt==1):
        #write headers
        print("reading header")
        nested_file.write(line)
        marginal_file.write(line)
        heterochromatic_file.write(line)

       line = fp.readline()
       array=line.split("\t")
       if (len(array)==13):
        row, motif, seq, start, end, strand, seqLen, querybp, mRatio, m, mm, i, d = array
        wiggle_room=int(100)
        #print(line)

        if ((int(start)-wiggle_room)<=0) and ((int(seqLen)-int(end))<=wiggle_room):
          #print("heterochromatic")
          heterochromatic_file.write(line)
        else:
          if ((int(start)-wiggle_room)>0) and ((int(seqLen)-int(end))>wiggle_room):
              #print("nested")
              nested_file.write(line)
          else:
              #print("marginal")
              marginal_file.write(line)

        cnt += 1
print("Finished writing. Check folders nested, marginal and heterochromatic. Done.")
nested_file.close()
marginal_file.close()
heterochromatic_file.close()
