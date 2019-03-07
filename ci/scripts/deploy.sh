#!/bin/bash
# hello-go-deploy-gce deploy.sh

set -e -x

# The code is located in /hello-go-deploy-gce
echo "List whats in the current directory"
ls -lat 
echo ""

# Setup the gopath based on current directory.
export GOPATH=$PWD

# All set and everything is in the right place for go
echo "Gopath is: $GOPATH"
echo "pwd is: $PWD"
echo ""

cd "$GOPATH"
# Check whats here
echo "List whats in top directory"
ls -lat 
echo ""

# List whats in the app.json file
echo "List whats in the app.json file"
cat hello-go-deploy-gce/app.json
