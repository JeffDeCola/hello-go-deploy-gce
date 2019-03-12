#!/bin/bash
# hello-go-deploy-gce destroy-pipeline.sh

fly -t ci destroy-pipeline --pipeline hello-go-deploy-gce
