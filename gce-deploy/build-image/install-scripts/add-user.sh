#!/bin/bash -e

echo "add-user.sh"

adduser --disabled-password --gecos "" larry

[ -d /root/.ssh ] || mkdir /root/.ssh

ssh-keyscan github.com >> /root/.ssh/known_hosts

echo "done add-user.sh"
