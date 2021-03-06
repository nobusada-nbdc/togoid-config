import csv
import re
from xml.etree import ElementTree


NAMESPACE = '{http://www.drugbank.ca}'
drugbank = ElementTree.parse('all-full-database.xml').getroot()

def id(drug):
    for dbid in drug.findall('./{0}drugbank-id'.format(NAMESPACE)):
        if re.match(r'DB\d+', dbid.text) is not None: return dbid.text 
    assert False

with open('pair.tsv', 'w', newline='') as file:
    tsv = csv.writer(file, delimiter='\t')
    for drug in drugbank.findall('./'):
        id1 = id(drug)
        for pubmedid in drug.findall('./{0}general-references/{0}articles/{0}article/{0}pubmed-id'.format(NAMESPACE)):
            tsv.writerow([id1, pubmedid.text])
