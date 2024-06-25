php /var/www/pterodactyl/artisan down
cd /var/www/pterodactyl
DIR="/var/www/pterodactyl/backup"
if [ -d "$DIR" ]; then
echo -n "$DIR' Do you want to restore your panel using the latest backup? y/n "
read answer

# if echo "$answer" | grep -iq "^y" ;then

  if [ "$answer" != "${answer#[Yy]}" ] ;then # this grammar (the #[] operator) means that the variable $answer where any Y or y in 1st position will be dropped if they exist.
    echo Yes
    cp -r ./backup/* ./
    if [ `which yum` ]; then
        if ! command -v node -v &> /dev/null
    then
        curl -sL https://rpm.nodesource.com/setup_16.x | sudo bash -
        yum install nodejs
    fi
    elif [ `which apt` ]; then
      if ! command -v node -v &> /dev/null
      then
        curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
        apt-get install -y nodejs
      fi
    else
       echo "Your OS is unsupported"
    fi
    if ! command -v yarn -v &> /dev/null
    then
        npm i -g yarn
    fi
    yarn install
    yarn build:production
    php artisan up
    echo "Backup restored!"
    exit
  else
      echo No
      php /var/www/pterodactyl/artisan up
  fi
else
   echo "There is no backup nothing to restore from!"
fi
