#!/bin/zsh
# Install:
# cowsay
# figlet and fonts
# neofetch
# no-more-secrets
# ruby and lolcat

echo "@@@ Start fun-packages.sh @@@"

if [[ "${fun_packages}" == "true" ]]; then

  # install figlet and fonts
  mkdir -p /usr/share/fonts/figlet-fonts/
  git clone https://github.com/xero/figlet-fonts.git /usr/share/fonts/figlet-fonts/
  amazon-linux-extras install epel -y
  yum install cowsay figlet no-more-secrets -y

  # install neofetch
  wget https://github.com/dylanaraps/neofetch/archive/master.zip -O /tmp/neofetch-master.zip
  unzip -q /tmp/neofetch-master.zip -d /tmp/
  cp /tmp/neofetch-master/neofetch /usr/local/bin/
  rm -Rf /tmp/neofetch-master/

  # install lolcat
  yum install ruby -y
  wget https://github.com/busyloop/lolcat/archive/master.zip  -O /tmp/lolcat-master.zip
  unzip -q /tmp/lolcat-master.zip -d /tmp/
  pushd /tmp/lolcat-master/
  gem install lolcat
  popd
  rm -Rf /tmp/lolcat-master/

  # add an ASCII name of your server to the motd
  cat << EOF > /etc/update-motd.d/40-fun-packages
#!/bin/sh
echo ""
/usr/bin/figlet -c -f /usr/share/fonts/figlet-fonts/Shadow ${application}
EOF
  chmod +x /etc/update-motd.d/40-fun-packages


  # dispay "end card"
  echo ""
  echo "Moo, you have choosen to install packages of fun. Let's see. \n First of all there is me: 'cowsay'. \n Then there is figlet and a couple of fun fonts. e.g. 'figlet -c -f /usr/share/fonts/figlet-fonts/3d.flf Hello World'" | cowsay
  echo ""
    /usr/bin/figlet -c -f /usr/share/fonts/figlet-fonts/3d.flf "Hello World"
  echo ""
  echo "'lolcat' can bring some color to your terminal. e.g. 'ls -al | lolcat' \n no-more-secrets is also fun. Try piping to 'nms'. e.g. 'ls -al | nms -a -c' \n 'neofetch' will show your instances system info." | cowsay
  echo ""
  /usr/local/bin/neofetch
  echo ""
  echo "Now 'Ctrl+C' and go on with your day...Moo!" | cowsay
  echo ""


else
  echo ""
  echo "No fun installed! All business ;)"
  echo "Ctrl+C and go on with your day.."
  echo ""
fi

echo "@@@ End fun-packages.sh @@@"
