#!/bin/sh
# hello-go-deploy-gce build-image.sh

echo " "

if [ "$1" = "-debug" ]
then
    echo "build-image.sh -debug (START)"
    echo " "
    # set -x enables a mode of the shell where all executed commands are printed to the terminal.
    set -x
    echo " "
else
    echo " "
    echo "build-image.sh (START)"
    echo " "
fi

echo "The goal is to create a custom image using packer on gce."
echo " "

packer build --force \
-var "account_file=/home/jeff/.gcloud/lofty-outcome-860.json" \
-var 'project_id=lofty-outcome-860' \
-var 'region=us-central1' \
-var 'zone=us-central1-b' \
-var 'environment=p' \
gce.json

echo "build-image.sh (END)"
echo " "
