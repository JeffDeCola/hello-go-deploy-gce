#!/bin/sh
# hello-go-deploy-gce deploy.sh

echo " "

if [ "$1" = "-debug" ]
then
    echo "deploy.sh -debug (START)"
    echo " "
    # set -x enables a mode of the shell where all executed commands are printed to the terminal.
    set -x
    echo " "
else
    echo " "
    echo "deploy.sh (START)"
    echo " "
fi

echo "The goal is to deploy to gce."
echo " "






echo "deploy.sh (END)"
echo " "
