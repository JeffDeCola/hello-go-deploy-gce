#!/bin/bash -e
# hello-go-deploy-gce autoscaling.sh

echo " "

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <instance-template>"
    echo "Use command: gcloud compute instance-templates list"
    echo " "
    exit 1
fi

if [ "$1" = "-debug" ]
then
    echo "autoscaling.sh -debug (START)"
    echo " "
    # set -x enables a mode of the shell where all executed commands are printed to the terminal.
    set -x
    echo " "
else
    echo " "
    echo "autoscaling.sh (START)"
    echo " "
fi

echo "The goal is to configure autoscaling on aa managed instance group on gce."
echo " "

TEMPLATENAME="$1"

echo "gcloud compute command"
gcloud compute \
    --project "$GOOGLE_JEFFS_PROJECT_ID" \
    instance-groups managed set-autoscaling "$TEMPLATENAME" \
    --min-num-replicas "1" \
    --max-num-replicas "2" \
    --cool-down-period "60" \
    --target-cpu-utilization "0.80" \
    --zone "us-west1-a" \
    --description "Autoscaling on Instance Group for Jeffs Repo hello-go-deploy-gce"
echo ""

echo "autoscaling.sh (END)"
echo " "
