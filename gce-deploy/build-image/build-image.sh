#!/bin/sh -e
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

echo "Check for -v switch"
if [ "$1" = "-v" ]
then
    echo "Validate this file"
    command="validate"
else
    echo "Lets build the image"
    command="build -force"
fi
echo " "

echo "packer build command"
packer $command \
    -var "account_file=$GOOGLE_APPLICATION_CREDENTIALS" \
    -var "project_id=$GOOGLE_JEFFS_PROJECT_ID" \
    gce-packer-template.json
echo " "

echo "build-image.sh (END)"
echo " "
