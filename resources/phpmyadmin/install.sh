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

# Install Addon
echo "=== Installing Addon ==="
cd /var/www/pterodactyl/public
rm -rf pma_redirect.html
wget https://raw.githubusercontent.com/Sigma-Production/PteroFreeStuffinstaller/V1.10.1/resources/phpmyadmin/pma_redirect.html

echo "Do you already have Phpmyadmin installed? y/n "
read answer

# if echo "$answer" | grep -iq "^y" ;then

if [ "$answer" != "${answer#[Yy]}" ]; then
    echo "Phpmyadmin will not be installed (you already have it?)"
    echo " "
    echo 'What is the url path of where phpMyAdmin is located? Make sure to have "http://" or "https://" !'
    echo " "
    echo "For example:"
    echo "https://pma.yourdomain.com"
    echo "OR"
    echo "https://panel.yourdomain.com/phpmyadmin"
    echo " "
    read pmalocation
    sed -i "s|http://yourdomain.com/phpmyadmin|$pmalocation|g" /var/www/pterodactyl/public/pma_redirect.html
else
    echo "No"
    echo 'What is the domain of your panel?'
    echo " "
    echo "For example:"
    echo "https://pterodactyl.myhosting.com"
    echo "OR"
    echo "https://panel.amazing.host"
    echo " "
    read panelurl
    sed -i "s|http://yourdomain.com/phpmyadmin|$panelurl/phpmyadmin|g" /var/www/pterodactyl/public/pma_redirect.html
    mkdir /var/www/pterodactyl/public/phpmyadmin && cd /var/www/pterodactyl/public/phpmyadmin
    wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-english.tar.gz
    tar xvzf phpMyAdmin-*-english.tar.gz
    mv /var/www/pterodactyl/public/phpmyadmin/phpMyAdmin-*-english/* /var/www/pterodactyl/public/phpmyadmin
    rm -rf /var/www/pterodactyl/phpMyAdmin-latest-english.tar.gz

fi

# Add the actual phpMyAdmin button
echo "=== Pulling DatabasesContainer.tsx from the repository ==="
cd /var/www/pterodactyl/resources/scripts/components/server/databases
rm -rf DatabasesContainer.tsx
wget https://raw.githubusercontent.com/Sigma-Production/PteroFreeStuffinstaller/V1.10.1/resources/phpmyadmin/DatabasesContainer.tsx

# Install NodeJS
cd /var/www/pterodactyl
echo "=== Installing NodeJS and Yarn ==="
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

# Build Panel
echo "=== Installing Dependencies ==="
yarn install

echo "=== Building Panel ==="
echo "--- WARNING: MAY TAKE SOME TIME ---"
echo "--- ON SOME SYSTEMS, BE PATIENT ---"
yarn build:production
#clear
chown -R www-data:www-data /var/www/pterodactyl/*
php /var/www/pterodactyl/artisan view:clear
php /var/www/pterodactyl/artisan config:clear
php /var/www/pterodactyl/artisan up

if [ "$answer" != "${answer#[Yy]}" ]; then
    echo "=== PhpMyAdmin Button Addon added ==="
else
    echo "=== PhpMyAdmin and Button Addon Added ==="
fi
