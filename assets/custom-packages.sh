#!/bin/zsh
# Install:
# custom packages as specified in tfvars
# brew.sh package manager

echo "@@@ Start custom-packages.sh @@@"

if [[ "${custom_packages}" != "" ]]; then
  echo "@@@ Installing custom packages @@@"
  yum install ${custom_packages} -y
fi

if [[ "${npm_packages}" != "" ]]; then
  echo "@@@ Installing npm packages @@@"
  runuser -l ${username} -c "source ~/.zshrc && npm install -g ${npm_packages}"
fi

if [[ "${install_brew}" == "true" ]]; then
  echo "@@@ Installing brew @@@"
  yum groupinstall 'Development Tools' -y
  runuser -l ${username} -c 'yes "" | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'

  grep -q "/home/linuxbrew/.linuxbrew/bin/brew shellenv" "/data/${username}/.zshrc" || runuser -l ${username} -c 'echo "eval \"\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)\"" >> ~/.zshrc'

  if [[ "${brew_packages}" != "" ]]; then
    echo "@@@ Installing brew packages @@@"
    runuser -l ${username} -c "/home/linuxbrew/.linuxbrew/bin/brew install ${brew_packages}"
  fi
fi

echo "@@@ End custom-packages.sh @@@"
