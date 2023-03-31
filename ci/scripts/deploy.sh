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

echo "GOAL ----------------------------------------------------------------------------------"
echo " "

echo "The goal is to Deploy a docker image to Google Compute Engine (gce)"
echo " "

echo "CHECK THINGS --------------------------------------------------------------------------"
echo " "

echo "At start, you should be in a /tmp/build/xxxxx directory with two folders:"
echo "   /hello-go-deploy-gce"
echo " "

echo "pwd is: $PWD"
echo " "

echo "List whats in the current directory"
ls -la
echo " "

echo "DEPLOY ---------------------------------------------------------------------------------"
echo " "

echo "DEPOY - PLACEHOLDER - DEPLOY"
echo " "

echo "deploy.sh (END)"
echo " "
