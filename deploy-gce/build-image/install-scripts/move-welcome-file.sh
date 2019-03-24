#!/bin/bash -e
# hello-go-deploy-gce move-welcome-file.sh

echo " "
echo "move-welcome-file.sh (START)"
echo " "

echo "pwd"
pwd
echo " "

echo "list contents"
ls -lat
echo " "

echo "list contents of .ssh"
ls -lat .ssh
echo " "

echo "cd /home/jeff"
cd /home/jeff
echo " "

echo "pwd"
pwd
echo " "

echo "list contents"
ls -lat
echo " "

echo "list contents of /tmp"
ls -lat /tmp
echo " "

echo "mv /tmp/welcome.txt /home/jeff"
mv /tmp/welcome.txt /home/jeff
echo " "

echo "list contents"
ls -lat
echo " "

echo "move-welcome-file.sh (END)"
echo " "