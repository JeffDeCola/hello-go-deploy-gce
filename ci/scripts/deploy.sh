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

echo "cd in create-instance-template folder"
cd ../create-instance-template
echo " "

echo "Kick off create-instance-template.sh"
sh create-instance-template.sh "$PREFIX-$SERVICE-inmage-$POSTFIX"
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
