#!/bin/sh
# SPARQL query
QUERY="PREFIX cco: <http://rdf.ebi.ac.uk/terms/chembl#>
SELECT   ?moleculeid ?interpro
WHERE{
  ?mechanism a cco:Mechanism ;
     cco:hasTarget ?target ;
     cco:hasMolecule ?molecule .
  ?target cco:hasTargetComponent ?component .
  ?component cco:targetCmptXref ?interpro_uri .
  BIND (REPLACE(STR(?interpro_uri), 'http://identifiers.org/interpro/', '') AS ?interpro)
  FILTER(CONTAINS(?interpro, "IPR"))
  ?molecule cco:chemblId ?moleculeid .
  }
ORDER BY ?moleculeid"
# curl -> format -> delete header
curl -s -H "Accept: text/csv" --data-urlencode "query=$QUERY" https://integbio.jp/rdf/mirror/ebi/sparql | sed -e 's/\"//g;  s/,/\t/g' | sed -e '1d' > pair.tsv
