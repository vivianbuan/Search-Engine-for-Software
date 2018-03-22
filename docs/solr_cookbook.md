# Solar Cookbook
This file list some commands that might be useful to run indexer.
## The tutorial
https://lucene.apache.org/solr/guide/7_2/solr-tutorial.html<br />
Please reference this page for how to strat node if needed.<br /> <br />
https://github.com/alisatl/solr-revolution-2016-nested-demo<br /> 
This is the tutorial for using nested document
## Ranking
### Start Node with LTR (Learning To Rank)
`bin/solr start -Dsolr.ltr.enabled=true`
### Installation of LTR (Learning To Rank)
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
### Uploading Features
`curl -XPUT 'http://localhost:8983/solr/nestedpackage/schema/feature-store' --data-binary "@./nestedpackage_features.json" -H 'Content-type:application/json'`
### Deleting Features
If there is already an existing feature store, you have to delete the existing features first before uploading new ones
`curl -XDELETE 'http://localhost:8983/solr/nestedpackage/schema/feature-store/nestedpackage_feature_store'`
### Uploading Model
`curl -XPUT 'http://localhost:8983/solr/nestedpackage/schema/model-store' --data-binary "@./nestedpackage_model.json" -H 'Content-type:application/json'`
### Deleting Model
If there is already an existing model, you have to delete the existing model first before uploading new ones
`curl -XDELETE 'http://localhost:8983/solr/nestedpackage/schema/model-store/nestedpackage_model'`

## Indexing with nested child
### Setting up
- Start solr: cd into `solr-7.2.0`, do <br />
```
$ ./bin/solr start -c -p 8983 -s example/cloud/node1/solr
$ ./bin/solr start -c -p 7574 -s example/cloud/node2/solr -z localhost:9983
```
- Create collection<br />
```
$ bin/solr create -c nestedpackage
```
- Add copy field
```
curl -X POST -H 'Content-type:application/json' --data-binary '{"add-copy-field" : {"source":"*","dest":"_text_"}}'\
        http://localhost:8983/solr/nestedpackage/schema
```
- Index files <br />
**important**: `-format solr` is needed to make the child documents work properly<br />
Right now the "real" data is in SOLR/solr-7.2.0/data/real
```
$ bin/post -c nestedpackage ./data/real/* -format solr
```
- Add new files to be indexed
```
curl 'http://localhost:8983/solr/test_nested/update?commit=true' --data-binary \
       @data/test_more_document_3.json -H 'Content-type:application/json'
```

- View the result from admin page: <br />
&ensp; 1. go to "http://35.230.82.124:8983/solr/#/" <br />
&ensp; 2. select "nestedpackage" from the drop-down box on left <br />
&ensp; 3. choose "query" on left. This will bring up the search user interface. <br />
&ensp; 4. Enter query term and click on "execute query" <br />
### Sample query
- Simple query: `curl "http://localhost:8983/solr/nestedpackage/select?q=YOURQUERY"`
- Query child field: `q=_childDocuments_.title:python`
- LTR query: `curl "http://localhost:8983/solr/nestedpackage/query?q=desc:python interface&rq={!ltr model=brew_formula_model efi.text_a=python efi.text_b=interface efi.text='python interface'}&fl=id,score,[features]"`
### List of query for Avery
- Sample results checkout: https://docs.google.com/document/d/1as7AEXQVZipIXmikV_0v6_66JLHpMZ2nWOvD6g4dWi0/edit?usp=sharing
- This page has some example on faceting for more query idea: https://github.com/alisatl/solr-revolution-2016-nested-demo
- Return a list of mixed information, that is both github package info and stackoverflow page/answer will returned as separate object (case 1 in google doc)
```
http://35.230.82.124:8983/solr/nestedpackage/select?q=[QUERYTERM]
```
- In the following command, if you want to query a string multiple terms like "hello world", the [QUERYTERM] should be 
```
\"hello+world\"
```
- Git packge info who has stackoverflow content containg [QUERYTERM] (case 2 in google doc) <br />
Note that this only contains git info, no stackoverflow info 
```
http://35.230.82.124:8983/solr/nestedpackage/select?
       q={!parent%20which=%22path:1.git%22}body_markdown:[QUERYTERM]
```
- Git packge info who has stackoverflow content containg [QUERYTERM] or itself contains [QUERYTERM]<br />
**This is probably the one you want to use**
```
http://35.230.82.124:8983/solr/nestedpackage/select?q=
       ({!parent%20which=%20path:1.git}body_markdown:[QUERYTERM])%20OR%20
       (path:1.git%20AND%20(name:[QUERYTERM]%20OR%20readMe:[QUERYTERM]%20or%20repo_keywords:[QUERYTERM]%20OR%20
       repo_description:[QUERYTERM]%20OR%20pm_name:[QUERYTERM]%20OR%20pm_description:[QUERYTERM]))
```
- Git package info for LTR query (essentially add a few parameters to the normal query, such as rq, the rerank parameter, and fl)
```
http://localhost:8983/solr/nestedpackage/select?q=%20({!parent%20which=%20path:1.git}body_markdown:python%20machine%20learning)%20OR%20(path:1.git%20AND%20(name:python%20machine%20learning%20OR%20readMe:python%20machine%20learning%20OR%20repo_keywords:python%20machine%20learning%20OR%20repo_description:python%20machine%20learning%20OR%20pm_name:python%20machine%20learning%20OR%20pm_description:python%20machine%20learning))&rq={!ltr model=nestedpackage_model efi.text='python machine learning'}&fl=name,repo_description,score,[features]
```
- Return a inner structure (case 3 in google doc) <br />
&ensp; There are two parts in this query, `q=...` is the regular query condition, `fl=...` is the filter of fields that we want to ouput. In this example we output `id,name,readMe,repo_url` of the outter most level (git package), then childs with the path `2.stack`. If you want to output all fields of outter most level, replace the first several term with `*`. <br />
&ensp; Nore that there are some limitations:<br />
&ensp; &ensp; 1. The descending structure is flattened, meaning that for any descendent (3.stack.answer), it is considered a direct child of level 1, instead of a grandchild. Replacing `childFilter=path:3.stack.answer` will return level 1 + level 3. <br />
&ensp; &ensp; 2. The field filter on child documents doesn't seem to work properly. Here I put `fl=title` in the filter but it is not doing anything.

```
http://35.230.82.124:8983/solr/nestedpackage/select?
fl=id,name,readMe,repo_url,%20
[child%20parentFilter=path:1.git%20childFilter=path:2.stack%20fl=title%20limit=2]
&q=path:1.git%20AND%20name:[QUERYTERM]
```
### Shutdown all Nodes
`bin/solr stop -all`
