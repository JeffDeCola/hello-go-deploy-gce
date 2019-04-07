#!/bin/bash
# hello-go-deploy-gce set-pipeline.sh

fly -t ci set-pipeline -p hello-go-deploy-gce -c pipeline.yml \
    --load-vars-from ../../../../../.credentials.yml \
    --var "gcp_jeffs_app_service_account_file=$(cat $GCP_JEFFS_APP_SERVICE_ACCOUNT_PATH | base64)" \
    --var "gcp_jeffs_app_service_account_email_address=$GCP_JEFFS_APP_SERVICE_ACCOUNT_EMAIL_ADDRESS" \
    --var "gcp_jeffs_project_id=$GCP_JEFFS_PROJECT_ID" \
    --var "gce_github_vm_file=$(cat $HOME/.ssh/gce-github-vm | base64)" \
    --var "gce_github_vm_pub_file=$(cat $HOME/.ssh/gce-github-vm.pub | base64)"
