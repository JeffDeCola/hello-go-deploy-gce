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

echo "packer build command"

if [ "$1" = "-v" ]
then
    command="validate"
else
    command="build --force"
fi

packer "$command" \
    -var "account_file=$GOOGLE_APPLICATION_CREDENTIALS" \
    -var "project_id=$GOOGLE_JEFFS_PROJECT_ID" \
    gce-packer-template.json

echo "build-image.sh (END)"
echo " "
