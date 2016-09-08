#!/usr/local/bin/python

import sys
import test
import os
import itertools
import re
from scipy import stats
import numpy as np
from collections import defaultdict

SAMdict = defaultdict(int)
positionsFile=sys.argv[1]

#for every gene in order of humanY
with open(positionsFile, "r") as outer:
    for outerline in itertools.islice(outer, 0, None, 4): 
        #print outerline
        array=re.split('  +', outerline.rstrip())
        error_pattern=array[1].rstrip()
        print ("x: " + str(error_pattern.count('x')))
        print ("=: " + str(error_pattern.count('=')))

        for i in range(0, len(error_pattern), 4): 
                for num in range(0,4): 
                    #print str(i+num)
                    if (i+num)<len(error_pattern):
                        character=error_pattern[i+num]
                        #print str(character)
                        if (character=='x'):
                            SAMdict[num]+=1

        print SAMdict
        table = np.array([[1,1,1,1], [SAMdict[0],SAMdict[1],SAMdict[2],SAMdict[3]]])
        pvalue=stats.chi2_contingency(table)[1]
        if (pvalue<=0.05):
            print ("pvalue: " + str(pvalue) + " BIAS reported")
        else:
            print ("pvalue: " + str(pvalue))
        SAMdict.clear()
        print



# Close opened file
outer.close()
