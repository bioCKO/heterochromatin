import os
import csv
import sys
import glob

IDs = {}

#open and store the csv file
with open('full_layout','rb') as csvfile:
        assocReader = csv.reader(csvfile, delimiter = ',', quotechar='"')
        next(assocReader, None)  # skip the headers

        # build a dictionary with the associated IDs
        for row in assocReader:
              #print row
              value=row[4].replace(' ','_')+"_"+row[5]+"_"+row[6]
              #print value
              IDs[ row[0] ] = value
#print IDs

#get the list of files
onlyfiles = glob.glob("SRR*")
tmpPath = 'SORT/'
for filename in onlyfiles:
    oldID = filename.split('_')[0]
    print oldID
    newFilename = (oldID + "_" + IDs[oldID] + "_" + filename.split('_')[1])
    os.rename(filename, tmpPath + newFilename)