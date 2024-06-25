#!/bin/bash

set -e


print_brake() {
  for ((n = 0; n < $1; n++)); do
    echo -n "#"
  done
  echo ""
}


hyperlink() {
  echo -e "\e]8;;${1}\a${1}\e]8;;\a"
}


#### Colors ####

GREEN="\e[0;92m"
YELLOW="\033[1;33m"
reset="\e[0m"


#### OS check ####

check_distro() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$(echo "$ID")
    OS_VER=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then
    OS=$(lsb_release -si)
    OS_VER=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then
    . /etc/lsb-release
    OS=$(echo "$DISTRIB_ID")
    OS_VER=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then
    OS="debian"
    OS_VER=$(cat /etc/debian_version)
  elif [ -f /etc/SuSe-release ]; then
    OS="SuSE"
    OS_VER="?"
  elif [ -f /etc/redhat-release ]; then
    OS="Red Hat/CentOS"
    OS_VER="?"
  else
    OS=$(uname -s)
    OS_VER=$(uname -r)
  fi

  OS=$(echo "$OS")
  OS_VER_MAJOR=$(echo "$OS_VER" | cut -d. -f1)
}



#### Install Dependencies ####
clear
dependencies() {
echo
print_brake 30
echo -e "* ${GREEN}Installing dependencies...${reset}"
print_brake 30
echo
case "$OS" in
debian | ubuntu)
curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash - && apt-get install -y nodejs && apt-get install -y zip
;;
esac

if [ "$OS_VER_MAJOR" == "7" ]; then
curl -sL https://rpm.nodesource.com/setup_16.x | sudo -E bash - && sudo yum install -y nodejs yarn && sudo yum install -y zip
fi

if [ "$OS_VER_MAJOR" == "8" ]; then
curl -sL https://rpm.nodesource.com/setup_16.x | sudo -E bash - && sudo dnf install -y nodejs && sudo dnf install -y zip
fi
}


#### Panel Backup ####
backup() {
echo
print_brake 32
echo -e "* ${GREEN}Performing security backup...${reset}"
print_brake 32
if [ -f "/var/www/pterodactyl/PanelBackup/PanelBackup.zip" ]; then
echo
print_brake 45
echo -e "* ${GREEN}There is already a backup, skipping step...${reset}"
print_brake 45
echo
else
cd /var/www/pterodactyl
mkdir -p PanelBackup
zip -r PanelBackup.zip app config public resources routes storage database .env tailwind.config.js
mv PanelBackup.zip PanelBackup
fi
}


#### Donwload Files ####
download_files() {
print_brake 25
echo -e "* ${GREEN}Downloading files...${reset}"
print_brake 25
cd /var/www/pterodactyl/resources/scripts/components/server/console/
rm PowerButtons.tsx
wget https://raw.githubusercontent.com/Sigma-Production/PteroFreeStuffinstaller/V1.10.1/resources/Kill-Button/PowerButtons.tsx
# cd /var/www/pterodactyl/resources/scripts/components/elements/
# rm Button.tsx
# wget https://raw.githubusercontent.com/finnie2006/PteroFreeStuffinstaller/V1.10.1/resources/Kill-Button/Button.tsx
}

#### Panel Production ####

production() {
DIR=/var/www/pterodactyl

if [ -d "$DIR" ]; then
echo
print_brake 25
echo -e "* ${GREEN}Producing panel...${reset}"
print_brake 25
npm i -g yarn
cd /var/www/pterodactyl
yarn install
yarn build:production
php artisan up
fi
}


bye() {
print_brake 50
echo
echo -e "* A backup for your panel has been created."
echo -e "* Serperate killbutton installed"
echo
print_brake 50
}


#### Exec Script ####
check_distro
dependencies
backup
download_files
production
bye
