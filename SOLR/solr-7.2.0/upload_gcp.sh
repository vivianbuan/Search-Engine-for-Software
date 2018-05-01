#!/bin/bash

# Upload files to google cloud compute
gcloud compute scp nestedpackage_features.json indexer:~ --ssh-key-file ~/.ssh/google_cloud
gcloud compute scp nestedpackage_model.json indexer:~ --ssh-key-file ~/.ssh/google_cloud
gcloud compute scp edit_model.sh indexer:~ --ssh-key-file ~/.ssh/google_cloud