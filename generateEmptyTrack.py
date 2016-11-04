import sys
import os
from os.path import basename
import subprocess as sp
import itertools
from itertools import izip

######################################
#python generateEmptyTrack.py motifFile
motifFile=str(sys.argv[1])
######################################

print motifFile
num_lines = open(motifFile).read().count('\n')

print num_lines
outputEmpty=motifFile + "EmptyTmp"

#sample same number of empty lines as are in motif file
bashCommand = "shuf -n " + str(num_lines) + " " + "Empty"
print bashCommand

p = sp.Popen(bashCommand.split(), stdin = sp.PIPE, stdout = sp.PIPE, stderr = sp.PIPE)
mf = open(motifFile,'r').readlines()
ef = p.stdout.read() #keep reshuffled empty lines
eff=ef.split('\n')

f = open(outputEmpty, 'w') #write results here

#read at the same time motifFile and EmptyTmp file and generate an output which will represent appropriate modeling of the empty windows with lengths mirroring lengths in feature files
print "looping"
for i in range(0,num_lines):
	#print i
	m=mf[i].rstrip() #line from motif file
	e=eff[i].rstrip() #line from matched empty file

	m_array=m.split('\t')
	e_array=e.split('\t')
	print (m_array[0:3])
	print (e_array[0:3])

	m_length=int(m_array[2])-int(m_array[1])+1
	e_middle_point=int(e_array[1])+(int(e_array[2])-int(e_array[1]))/2+1
	print ("motif length: " + str(m_length))
	print ("e_middle_point: " + str(e_middle_point))
	if (m_length % 2 == 0): #even 
		print "even"
		res=(e_array[0] + "\t" + str(e_middle_point-(m_length/2)) + "\t" + str(e_middle_point+(m_length/2)-1))
	else: #odd
		print "odd"
		res=(e_array[0] + "\t" + str(e_middle_point-(m_length/2)) + "\t" + str(e_middle_point+(m_length/2)))
	print res
	f.write(res+"\n")
	print "***"



