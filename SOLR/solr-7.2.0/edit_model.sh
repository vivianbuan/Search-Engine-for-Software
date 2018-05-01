#!/bin/bash

# Delete both features and model
curl -XDELETE 'http://localhost:8983/solr/nestedpackage/schema/feature-store/nestedpackage_feature_store'
curl -XDELETE 'http://localhost:8983/solr/nestedpackage/schema/model-store/nestedpackage_model'

# Upload both features and model
curl -XPUT 'http://localhost:8983/solr/nestedpackage/schema/feature-store' --data-binary "@./nestedpackage_features.json" -H 'Content-type:application/json'
curl -XPUT 'http://localhost:8983/solr/nestedpackage/schema/model-store' --data-binary "@./nestedpackage_model.json" -H 'Content-type:application/json'

# Restart Solr node
bin/solr stop -all
bin/solr start -Dsolr.ltr.enabled=true -force