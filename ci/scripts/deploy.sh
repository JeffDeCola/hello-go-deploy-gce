#!/bin/sh
# hello-go-deploy-gce deploy.sh

echo " "

if [ "$1" = "-debug" ]
then
    echo "deploy.sh -debug (START)"
    # set -e causes the shell to exit if any subcommand or pipeline returns a non-zero status. Needed for concourse.
    # set -x enables a mode of the shell where all executed commands are printed to the terminal.
    set -e -x
    echo " "
else
    echo "deploy.sh (START)"
    # set -e causes the shell to exit if any subcommand or pipeline returns a non-zero status.  Needed for concourse.
    set -e
    echo " "
fi

PREFIX="jeff"
SERVICE="hello-go"
#POSTFIX=$(date -u +%Y%m%d-%H%M)
POSTFIX=$(date -u +%Y%m%d)

echo "The goal is to send the docker image to gce"
echo "   This will be done in 3 steps"
echo "   STEP 1 - Build a custom image using packer"
echo "   STEP 2 - Create an instance template "
echo "   STEP 3 - Create an instance group"
echo " "

echo "At start, you should be in a /tmp/build/xxxxx directory with one folder:"
echo "   /hello-go-deploy-gce"
echo " "

echo "PRESTEPS"
echo " "

echo "Note: $GOOGLE_JEFFS_PROJECT_ID AND $GOOGLE_SERVICE_ACCOUNT_EMAIL_ADDRESS env variable already preset"
echo " "

echo "Write credential.json file to /root from preset $GOOGLE_APPLICATION_CREDENTIALS_FILE"
echo "$GOOGLE_APPLICATION_CREDENTIALS_FILE" | base64 -d > /root/google-credentials.json

echo "Set $GOOGLE_APPLICATION_CREDENTIALS (file location) env variable"
export GOOGLE_APPLICATION_CREDENTIALS="/root/google-credentials.json"
echo " "

echo "Make /root/.ssh"
[ -d /root/.ssh ] || mkdir /root/.ssh
echo " "

echo "Write private key to /root/.ssh/gce-github-vm"
echo "$GCE_GITHUB_VM_FILE" | base64 -d > "/root/.ssh/gce-github-vm"
echo " "

echo "Write public key to /root/.ssh/gce-github-vm.pub"
echo "$GCE_GITHUB_VM_PUB_FILE" | base64 -d > "/root/.ssh/gce-github-vm.pub"
echo " "

echo "gcloud auth"
echo gcloud auth activate-service-account "$GOOGLE_SERVICE_ACCOUNT_EMAIL_ADDRESS" --key-file "$GOOGLE_APPLICATION_CREDENTIALS"
gcloud auth activate-service-account "$GOOGLE_SERVICE_ACCOUNT_EMAIL_ADDRESS" --key-file "$GOOGLE_APPLICATION_CREDENTIALS"
echo " "

echo "gcloud config set project $GOOGLE_JEFFS_PROJECT_ID"
gcloud config set project "$GOOGLE_JEFFS_PROJECT_ID"
echo " "

echo "STEP 1 - Build a custom image using packer"
echo "Your boot disk that contains all your stuff (the hello-go-deploy-gce docker image)"

echo "cd hello-go-deploy-gce/deploy-gce/build-image"
cd hello-go-deploy-gce/deploy-gce/build-image
echo " "

echo "Kick off build-image.sh"
sh build-image.sh
echo " "

echo "STEP 2 - Create an instance template"
echo "What HW resources you want for your VM instance"

echo "delete any instance-groups or instance templates (-q quiet mode)"
gcloud compute -q instance-groups managed delete --zone "us-west1-a" "$PREFIX-$SERVICE-instance-group-$POSTFIX"
gcloud compute -q instance-templates delete "$PREFIX-$SERVICE-instance-template-$POSTFIX"

echo "cd in create-instance-template folder"
cd ../create-instance-template
echo " "

echo "Kick off create-instance-template.sh"
sh create-instance-template.sh "$PREFIX-$SERVICE-image-$POSTFIX"
echo " "

echo "STEP 3 - Create an instance group"
echo "Will deploy and scale you VM instance(s)"
echo " "

echo "cd in create-instance-group folder"
cd ../create-instance-group
echo " "

echo "Kick off create-instance-group.sh"
sh create-instance-group.sh "$PREFIX-$SERVICE-instance-template-$POSTFIX"
echo " "

echo "deploy.sh (END)"
echo " "
