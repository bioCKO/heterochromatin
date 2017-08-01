import sys
import xml.etree.ElementTree as ET

######################################
#python python extract_from_xml.py test.xml
#Extracts the chemistry type from pacbio metadata.xml file
######################################

tree = ET.parse(sys.argv[1])
root = tree.getroot()

for child in root:
	if ('BindingKit' in child.tag):
		for prop in child:
			if ('Name' in prop.tag):
				print(prop.text)

