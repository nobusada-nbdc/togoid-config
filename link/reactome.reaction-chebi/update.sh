#!/bin/sh

# 20210204 moriya

# SPARQL query
QUERY="PREFIX biopax: <http://www.biopax.org/release/biopax-level3.owl#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
SELECT DISTINCT ?reaction ?chebi
FROM <http://rdf.ebi.ac.uk/dataset/reactome>
WHERE {
  VALUES ?has_component { biopax:left biopax:right biopax:product }
  ?react biopax:xref [
      biopax:db 'Reactome'^^xsd:string ;
      biopax:id ?reaction
  ] ;
    ?has_component ?component .
  ?component biopax:component*/biopax:entityReference/biopax:xref [
    biopax:db 'ChEBI'^^xsd:string ;
    biopax:id ?chebi
  ] .
}"

# curl -> format -> delete header
curl -s -H "Accept: text/csv" --data-urlencode "query=$QUERY" https://integbio.jp/rdf/mirror/ebi/sparql | sed -e 's/\"//g; s/,/\t/g; s/CHEBI://g' | sed  -n '2,$p' 

