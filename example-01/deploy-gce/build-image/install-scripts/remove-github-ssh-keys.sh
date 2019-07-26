#!/bin/bash -e
# hello-go-deploy-gce remove-github-ssh-keys.sh

echo " " 
echo "************************************************************************"
echo "************************************ remove-github-ssh-keys.sh (START) *"
echo "You are root in /home/packer"
echo " "

echo "cd /root/.ssh"
cd /root/.ssh

echo "Remove keys"
rm id_rsa
rm id_rsa.pub
echo " "

echo "************************************** remove-github-ssh-keys.sh (END) *"
echo "************************************************************************"
echo " "