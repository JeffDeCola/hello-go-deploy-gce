#!/bin/bash
# hello-go-deploy-gce set-pipeline.sh

fly -t ci set-pipeline -p hello-go-deploy-gce -c pipeline.yml --load-vars-from ../../../../../.credentials.yml
