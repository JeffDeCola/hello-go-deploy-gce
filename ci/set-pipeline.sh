#!/bin/bash
# hello-go-deploy-gce set-pipeline.sh

fly -t ci set-pipeline -p hello-go-deploy-gce -c pipeline.yml \
    --load-vars-from ../../../../../.credentials.yml \
    --var "google_application_credentials_file=$(cat $GOOGLE_APPLICATION_CREDENTIALS | base64)" \
    --var "google_jeffs_project_id=$GOOGLE_JEFFS_PROJECT_ID" \
    --var "gce-github-vm-file=$(cat $HOME/.ssh/gce-github-vm | base64)" \
    --var "gce-github-vm-pub-file=$(cat $HOME/.ssh/gce-github-vm.pub | base64)"
