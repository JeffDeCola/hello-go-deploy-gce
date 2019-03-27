#!/bin/bash -e
# hello-go-deploy-gce install-service.sh

echo " " 
echo "************************************************************************"
echo "******************************************* install-service.sh (START) *"
echo "You are root in /home/packer"
echo " "

echo "cd into /root/src/github.com/JeffDeCola/hello-go-deploy-gce"
cd /root/src/github.com/JeffDeCola/hello-go-deploy-gce
echo " "

echo "Build an executable, place in /root/bin"
go build -o /root/bin/hello-go main.go
echo " "

echo "********************************************* install-service.sh (END) *"
echo "************************************************************************"
echo " "