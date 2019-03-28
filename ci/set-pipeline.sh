#!/bin/bash
# hello-go-deploy-gce set-pipeline.sh

fly -t ci set-pipeline -p hello-go-deploy-gce -c pipeline.yml \
    --load-vars-from ../../../../../.credentials.yml \
    --var "google_application_credentials_file=$(cat $GOOGLE_APPLICATION_CREDENTIALS | base64)" \
    --var "google_jeffs_project_id=$GOOGLE_JEFFS_PROJECT_ID"
