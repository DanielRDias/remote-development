#!/bin/bash

echo "@@@ Start zsh10k.sh @@@"

# Wait for user home to be created
while [ ! -e ${mount_point}/${username} ]; do echo Waiting for user home; sleep 5; done

# Required to change the login shell to zsh
yum install util-linux-user -y
# Git is a "pre-requisite" for this installation
yum install git -y

# Oh My Zsh
yum install zsh -y
runuser -l ${username} -c 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended'
chsh -s "$(command -v zsh)" ${username}


# If powerlevel10k is already installed, we update
if [ -d /data/${username}/powerlevel10k ]; then
  runuser -l ${username} -c 'cd ~/powerlevel10k && git pull'
else
  runuser -l ${username} -c 'git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k'
  runuser -l ${username} -c 'echo "source ~/powerlevel10k/powerlevel10k.zsh-theme" >> ~/.zshrc'
fi

echo "@@@ End zsh10k.sh @@@"
