#!/bin/bash -e
# hello-go-deploy-gce create-instance-group.sh

echo " "

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <instance-template>"
    echo "Use command: gcloud compute instance-templates list"
    echo " "
    exit 1
fi

if [ "$1" = "-debug" ]
then
    echo "create-instance-group.sh -debug (START)"
    echo " "
    # set -x enables a mode of the shell where all executed commands are printed to the terminal.
    set -x
    echo " "
else
    echo " "
    echo "create-instance-group.sh (START)"
    echo " "
fi

echo "The goal is to create a managed instance group on gce."
echo " "

TEMPLATENAME="$1"
PREFIX="jeff"
SERVICE="hello-go"
#POSTFIX=$(date -u +%Y%m%d-%H%M)
POSTFIX=$(date -u +%Y%m%d)

echo "gcloud compute command"
gcloud compute \
    --project "$GOOGLE_JEFFS_PROJECT_ID" \
    instance-groups managed create "$PREFIX-$SERVICE-instance-group-$POSTFIX" \
    --size "1" \
    --template "$TEMPLATENAME" \
    --base-instance-name "$PREFIX-$SERVICE-instance-$POSTFIX" \
    --zone "us-west1-a" \
    --description "Instance Group for Jeffs Repo hello-go-deploy-gce"
echo ""

echo "create-instance-group.sh (END)"
echo " "
