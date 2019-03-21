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

echo "The goal is to send the docker image to gce"
echo ""
echo ""
echo ""
echo " "

echo "At start, you should be in a /tmp/build/xxxxx directory with two folders:"
echo "   /hello-go-deploy-gce"
echo " "

echo "pwd is: $PWD"
echo " "

echo "List whats in the current directory"
ls -la
echo " "

echo "cd hello-go-deploy-gce"
cd hello-go-deploy-gce
echo " "

echo "List whats in the current directory"
ls -la
echo " "

echo "STEP ONE Build the image"

echo "deploy.sh (END)"
echo " "
