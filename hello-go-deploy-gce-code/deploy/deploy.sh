#!/bin/sh
# hello-go-deploy-aks deploy.sh

echo " "

if [ "$1" = "-debug" ]
then
    echo "************************************************************************"
    echo "* deploy.sh -debug (START) *********************************************"
    echo "************************************************************************"
    # set -x enables a mode of the shell where all executed commands
    # are printed to the terminal.
    set -x
    echo " "
else
    echo "************************************************************************"
    echo "* deploy.sh (START) ****************************************************"
    echo "************************************************************************"
    echo " "
fi

echo "Send app.json file to marathon"
curl -X PUT http://localhost:8080/v2/apps/hello-go-long-running \
     -d @app.json \
     -H "Content-type: application/json"
echo " "
echo " "

echo "************************************************************************"
echo "* deploy.sh (END) ******************************************************"
echo "************************************************************************"
echo " "
