#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELL='\033[0;33m'
BLU='\033[0;34m'
NC='\033[0m' # No Color

UBUNTU_VERSION="xenial"
MONGO_VERSION="3.2"

programs=(Nodejs Foreverjs MongoDB python build-essential yarn)

function _installNvm {
  printInstallingMessage "nvm"
  dest_script=/tmp/nvm_installer.sh
  wget -O $dest_script https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh
  chmod 755 $dest_script
  $dest_script
  rm $dest_script
}

function printInstallingMessage {
  printf "${GREEN}Installing $1...${NC}\n"
}

function installYarn {
  if [ -f $HOME/.yarn ]; then
    echo "Yarn already installed"
    return
  fi

  printInstallingMessage "yarn"
  dest_script=/tmp/yarn_installer.sh
  wget -O $dest_script https://yarnpkg.com/install.sh
  chmod 755 $dest_script
  $dest_script
  rm $dest_script
}

function installPython {
  printInstallingMessage "python Ubuntu package"
  sudo apt-get --yes install python
}

function installBuildEssential {
  printInstallingMessage "build-essential Ubuntu package"
  sudo apt-get --yes install build-essential
}

function installNode {

  _installNvm
  printInstallingMessage Nodejs

  #This export is useful to avoid logout and reconnect
  export NVM_DIR="$HOME/.nvm" 
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" 
  nvm install node

}

function installMongo {
  printInstallingMessage MongoDB
  # Import the public key used by the package management system
  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
  # Create a list file for MongoDB
  echo "deb http://repo.mongodb.org/apt/ubuntu $UBUNTU_VERSION/mongodb-org/$MONGO_VERSION multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-$MONGO_VERSION.list
  # Reload local package database.
  sudo apt-get update
  # Install the MongoDB packages
  sudo apt-get install -y mongodb-org
}

function installForever {
  printInstallingMessage Foreverjs
  npm i -g forever
}


function install {
  install=false
  while true; do
    read -p "Do you wish to install $1? [y/n] " yn
    case $yn in
        [Yy]* ) install=true; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
  done

  if [ $install = true ]
  then
    case $1 in
      build-essential) installBuildEssential;;
      python) installPython;;
      Nodejs) installNode;;
      Foreverjs) installForever;;
      MongoDB) installMongo;;
      yarn) installYarn;;
    esac
  fi
}


# Fix for language problem
export LC_ALL=C
sudo echo "LC_ALL=en_US.UTF-8" > /etc/default/locale
sudo echo "LANGUAGE=en_US" >> /etc/default/locale
sudo echo "LANG=en_US.UTF-8" >> /etc/default/locale

# Adding nodejs user
sudo useradd nodejs -m -s /bin/bash

# Installing ssl script
mkdir ~/.bons
curl -O https://raw.githubusercontent.com/bons/b-bash-scripts/master/scripts/ssl.sh
mv ssl.sh ~/.bons
chmod 755 ~/.bons/ssl.sh
sudo ln -s ~/.bons/ssl.sh /usr/local/bin/b-ssl

# Updating apt
sudo apt-get update

for i in "${programs[@]}"
do
  install $i
done

printf "${GREEN}Setup completed, enjoy! ^^${NC}\n"
printf "Please use the user ${YELL}nodejs${NC} to run your nodejs process\n connect as nodejs using ${BLU}sudo su nodejs${NC}, add your public ssh key if you want\n"
printf "Note that if you want to use ${YELL}yarn${NC} or ${YELL}nvm${NC} you most logout and reconnect\n"
