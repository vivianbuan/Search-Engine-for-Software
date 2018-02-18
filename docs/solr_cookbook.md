# Solar Cookbook
This file list some commands that might be useful to run indexer.
## The tutorial
https://lucene.apache.org/solr/guide/7_2/solr-tutorial.html<br />
Please reference this page for how to strat node if needed.
## Sample query
- Simple query: `curl "http://localhost:8983/solr/techproducts/select?q=YOURQUERY"`
- Quey child field: `q=_childDocuments_.title:python`
