import sys
import os
from os.path import basename

######################################
#python checkConsistency.py motifFile
motifFile=str(sys.argv[1])
######################################
formattedFile=motifFile.replace(".txt",".Formatted.txt")

print motifFile

f = open(formattedFile, 'w') #write results here

#read motifFile and generate an output that is reformatted and checked for the consistency
i=0

with open(motifFile, "r") as ifile:
	for line in ifile:
		i=i+1 #line count
		m=line.rstrip() #line from motif file
		#print m
		m_array=m.split(' ')
		
		try:
			chromosome=int(m_array[0])
			print chromosome
			if (i!=1):
				f.write("\n") #write newline, except for reading first line
			f.write(m)
		except ValueError:
			print "Oops!  That was not valid chromosome.  I will not add newline to this line."
			last_entry=m_array[-1]
			print last_entry
			f.write(m) #the newline shouldn't be there, it's not chromosome
