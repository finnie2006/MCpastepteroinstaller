php /var/www/pterodactyl/artisan down
cd /var/www/pterodactyl/resources/views/admin/servers
rm -rf index.blade.php
wget https://raw.githubusercontent.com/Sigma-Production/PteroFreeStuffinstaller/V1.10.1/resources/MoreServerInfo/index.blade.php
clear
yarn run build:production
php /var/www/pterodactyl/artisan up
clear
echo "MoreServerInfo Installed"
