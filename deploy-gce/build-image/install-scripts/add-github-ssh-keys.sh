#!/bin/bash -e
# hello-go-deploy-gce add-github-ssh-keys.sh

echo " " 
echo "add-github-ssh-keys.sh (START)"
echo " "

echo "Make directory /root/.ssh"
[ -d /root/.ssh ] || mkdir /root/.ssh
echo " "

echo "create keys via ssh-keyscan gihub.com"
ssh-keyscan github.com >> /root/.ssh/known_hosts
echo " "

echo "add-github-ssh-keys.sh (END)"
echo " "