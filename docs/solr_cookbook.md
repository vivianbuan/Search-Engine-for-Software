# Solar Cookbook
This file list some commands that might be useful to run indexer.
## The tutorial
https://lucene.apache.org/solr/guide/7_2/solr-tutorial.html<br />
Please reference this page for how to strat node if needed.
## Start Node
./bin/solr start -c -p 8983 -s example/cloud/node1/solr<br />
./bin/solr start -c -p 7574 -s example/cloud/node2/solr -z localhost:9983<br />
## Sample query
- Simple query: `curl "http://localhost:8983/solr/techproducts/select?q=YOURQUERY"`
- Quey child field: `q=_childDocuments_.title:python`
