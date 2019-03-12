#!/bin/sh
# hello-go-deploy-gce deploy.sh

echo " "

if [ "$1" = "-debug" ]
then
    echo "readme-github-pages.sh -debug (START)"
    echo " "
    # set -x enables a mode of the shell where all executed commands are printed to the terminal.
    set -x
    echo " "
else
    echo " "
    echo "readme-github-pages.sh (START)"
    echo " "
fi

echo "Send app.json file to marathon"
curl -X PUT http://10.141.141.10:8080/v2/apps/hello-go-long-running -d @app.json -H "Content-type: application/json"
echo " "

echo "deploy.sh (END)"
echo " "
