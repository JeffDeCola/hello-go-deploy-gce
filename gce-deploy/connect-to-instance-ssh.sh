#!/bin/sh
# hello-go-deploy-gce deploy.sh

echo " "

gcloud compute \
    --project "jeffs-project-174816" \
    ssh \
    --zone "us-west1-a" \
    "jeffs-instance"
