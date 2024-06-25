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

cd /var/www/pterodactyl/resources/views/admin
rm -rf statistics.blade.php
wget https://raw.githubusercontent.com/Sigma-Production/PteroFreeStuffinstaller/V1.10.1/resources/statistics/statistics.blade.php
cd /var/www/pterodactyl/resources/views/layouts
rm -rf admin.blade.php
wget https://raw.githubusercontent.com/Sigma-Production/PteroFreeStuffinstaller/V1.10.1/resources/statistics/admin.blade.php
cd /var/www/pterodactyl/app/Http/Controllers/Admin
rm -rf StatisticsController.php
wget https://raw.githubusercontent.com/Sigma-Production/PteroFreeStuffinstaller/V1.10.1/resources/statistics/StatisticsController.php
cd /var/www/pterodactyl/public/themes/pterodactyl/js/admin
rm -rf statistics.js
wget https://raw.githubusercontent.com/Sigma-Production/PteroFreeStuffinstaller/V1.10.1/resources/statistics/statistics.js
cd /var/www/pterodactyl/routes
rm -rf admin.php
wget https://raw.githubusercontent.com/Sigma-Production/PteroFreeStuffinstaller/V1.10.1/resources/statistics/admin.php
cd /var/www/pterodactyl/app/Repositories/Eloquent
rm ServerRepository.php
wget https://raw.githubusercontent.com/Sigma-Production/PteroFreeStuffinstaller/V1.10.1/resources/statistics/ServerRepository.php
cd /var/www/pterodactyl/app/Contracts/Repository
rm ServerRepositoryInterface.php
wget https://raw.githubusercontent.com/Sigma-Production/PteroFreeStuffinstaller/V1.10.1/resources/statistics/ServerRepositoryInterface.php

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

echo "=== Statistics Addon added ==="