php /var/www/pterodactyl/artisan down
cd /var/www/pterodactyl
DIR="/var/www/pterodactyl/backup"
if [ -d "$DIR" ]; then
  echo -n "$DIR' There already is a backup do you want to create a new one? y/n "
  read answer

  # if echo "$answer" | grep -iq "^y" ;then

  if [ "$answer" != "${answer#[Yy]}" ]; then # this grammar (the #[] operator) means that the variable $answer where any Y or y in 1st position will be dropped if they exist.
    echo Yes
    rm -r backup/*
    mkdir -p backup/{resources,public}
    cp -r resources/* backup/resources/
    cp -r public/* backup/public/
    cp tailwind.config.js backup/
    echo "Created Backup going further"
  else
    echo No
  fi

else
  echo "No backup found making one"
  mkdir -p backup/{resources,public}
  cp -r resources/* backup/resources/
  cp -r public/* backup/public/
  cp tailwind.config.js backup/
  echo "Created Backup going further"
fi

sudo curl https://raw.githubusercontent.com/Sigma-Production/PteroFreeStuffinstaller/V1.10.1/resources/DarkNYellow/DarkNYellow.tar.gz | sudo tar -xz
#clear
cd /var/www/pterodactyl

if [ $(which yum) ]; then
  if ! command -v node -v &>/dev/null; then
    curl -sL https://rpm.nodesource.com/setup_16.x | sudo bash -
    yum install nodejs
  fi
elif [ $(which apt) ]; then
  if ! command -v node -v &>/dev/null; then
    curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
    apt-get install -y nodejs
  fi
else
  echo "Your OS is unsupported"
fi

if ! command -v yarn -v &>/dev/null; then
  npm i -g yarn
fi
yarn install
yarn build:production
#clear
chown -R www-data:www-data /var/www/pterodactyl/*
php artisan view:clear
php artisan config:clear
php /var/www/pterodactyl/artisan up
echo "DarkNYellow theme added"
