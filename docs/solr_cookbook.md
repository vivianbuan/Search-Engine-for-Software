# Solar Cookbook
This file list some commands that might be useful to run indexer.
## The tutorial
https://lucene.apache.org/solr/guide/7_2/solr-tutorial.html<br />
Please reference this page for how to start node if needed.
## Start Node with LTR (Learning To Rank)
`bin/solr start -Dsolr.ltr.enabled=true`
## Installation of LTR (Learning To Rank)
Copy and paste the following into `/path/to/solr-<version>/solr/server/solr/nestedpackage/conf/solrconfig.xml`, between the `<config>` brackets:
`<lib dir="${solr.install.dir:../../../..}/contrib/ltr/lib/" regex=".*\.jar" />`
`<lib dir="${solr.install.dir:../../../..}/dist/" regex="solr-ltr-\d.*\.jar" />`
`<queryParser name="ltr" class="org.apache.solr.ltr.search.LTRQParserPlugin"/>`
`<cache name="QUERY_DOC_FV"
       class="solr.search.LRUCache"
       size="4096"
       initialSize="2048"
       autowarmCount="4096"
       regenerator="solr.search.NoOpRegenerator" />`
`<transformer name="features" class="org.apache.solr.ltr.response.transform.LTRFeatureLoggerTransformerFactory">
  <str name="fvCacheName">QUERY_DOC_FV</str>
</transformer>`
## Uploading Features
`curl -XPUT 'http://localhost:8983/solr/nestedpackage/schema/feature-store' --data-binary "@./data/brew_formula_features.json" -H 'Content-type:application/json'`
## Deleting Features
If there is already an existing feature store, you have to delete the existing features first before uploading new ones
`curl -XDELETE 'http://localhost:8983/solr/nestedpackage/schema/feature-store/brew_formula_feature_store'`
## Uploading Model
`curl -XPUT 'http://localhost:8983/solr/nestedpackage/schema/model-store' --data-binary "@./data/brew_formula_model.json" -H 'Content-type:application/json'`
## Sample query
- Simple query: `curl "http://localhost:8983/solr/nestedpackage/select?q=YOURQUERY"`
- Query child field: `q=_childDocuments_.title:python`
- LTR query: `curl "http://localhost:8983/solr/nestedpackage/query?q=python visualization&df=desc&rq={!ltr model=brew_formula_model efi.text_a=python efi.text_b=visualization efi.text='python visualization'}&fl=name,desc,[features]"`
## Shutdown all Nodes
`bin/solr stop -all`