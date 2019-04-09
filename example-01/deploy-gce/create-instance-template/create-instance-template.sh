#!/bin/bash -e
# hello-go-deploy-gce create-instance-template.sh

echo " "
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <image> -debug"
    echo "Use command: gcloud compute images list --no-standard-images"
    echo " "
    exit 1
fi

if [ "$2" = "-debug" ] || [ "$1" = "-debug" ]
then
    echo "************************************************************************"
    echo "* create-instance-template.sh -debug (START) ***************************"
    echo "************************************************************************"
    # set -x enables a mode of the shell where all executed commands are printed to the terminal.
    set -x
    echo " "
else
    echo "************************************************************************"
    echo "* create-instance-template.sh (START) **********************************"
    echo "************************************************************************"
    echo " "
fi

echo "The goal is to create an instance template on gce."
echo " "

IMAGENAME="$1"
PREFIX="jeff"
SERVICE="hello-go"
#POSTFIX=$(date -u +%Y%m%d-%H%M)
POSTFIX=$(date -u +%Y%m%d)

echo "gcloud compute command"
gcloud compute \
    --project "$GCP_JEFFS_PROJECT_ID" \
     instance-templates create "$PREFIX-$SERVICE-instance-template-$POSTFIX" \
    --machine-type "f1-micro" \
    --network "default" \
    --maintenance-policy "TERMINATE" \
    --tags "jeff-test" \
    --image "$IMAGENAME" \
    --boot-disk-size "10" \
    --boot-disk-type "pd-standard" \
    --boot-disk-device-name "$PREFIX-$SERVICE-disk-$POSTFIX" \
    --description "Instance Template for Jeffs Repo hello-go-deploy-gce" \
    --region "us-west1" \
    # --service-account=""
    # --preemptible \
echo " "

echo "************************************************************************"
echo "* create-instance-template.sh (END) ************************************"
echo "************************************************************************"
echo " "
