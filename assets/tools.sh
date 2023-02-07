#!/bin/bash
# Install:
# nvm
# git
# adfs-cli

echo "@@@ Start tools.sh @@@"

# Wait for user home to be created
while [ ! -e ${mount_point}/${username} ]; do echo Waiting for user home; sleep 5; done

# node nvm 
yum install -y gcc-c++ make
runuser -l ${username} -c "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash"
runuser -l ${username} -c "source ~/.nvm/nvm.sh && nvm install --lts"

# Git
yum install git -y

# Config git
[[ ! -z "${GIT_EMAIL}" ]] && runuser -l ${username} -c 'git config --global user.email "${GIT_EMAIL}"'
[[ ! -z "${GIT_NAME}" ]] && runuser -l ${username} -c 'git config --global user.name "${GIT_NAME}"'

echo "@@@ End tools.sh @@@"