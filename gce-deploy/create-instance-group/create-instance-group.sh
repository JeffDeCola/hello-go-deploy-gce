#!/bin/sh
# hello-go-deploy-gce create-instance-group.sh

echo " "

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

echo "The goal is to create a custom image using packer on gce."
echo " "






echo "create-instance-group.sh (END)"
echo " "
