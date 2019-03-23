#!/bin/bash -e

echo " "
echo "move-welcome-file.sh (START)"
echo " "

pwd
echo " "

ls -lat
echo " "

ls -lat .ssh
echo " "

cd /home/jeff
echo " "

pwd
echo " "

ls -lat
echo " "

ls -lat /tmp
echo " "

mv /tmp/welcome.txt /home/jeff
echo " "

ls -lat
echo " "

echo "move-welcome-file.sh (END)"
echo " "