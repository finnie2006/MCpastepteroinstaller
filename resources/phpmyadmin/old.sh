php /var/www/pterodactyl/artisan down
cd /var/www/pterodactyl/public
rm -rf pma_redirect.html
wget https://raw.githubusercontent.com/Sigma-Production/PteroFreeStuffinstaller/V1.10.1/resources/phpmyadmin/pma_redirect.html

echo "Do you already have Phpmyadmin installed? y/n "
read answer

# if echo "$answer" | grep -iq "^y" ;then

if [ "$answer" != "${answer#[Yy]}" ] ;then 
    echo "Phpmyadmin will not be installed (you already have it?)"
    echo " "
echo 'Where is phpMyAdmin located? Make sure to have "http://" or "https://" !'
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
echo 'What is the url of your panel" !'
echo " "
echo "For example:"
echo "https://pterodactyl.myhosting.com"
echo "OR"
echo "https://panel.zhosting.com"
echo " "
read panelurl
sed -i "s|http://yourdomain.com/phpmyadmin|$panelurl/phpmyadmin|g" /var/www/pterodactyl/public/pma_redirect.html
mkdir /var/www/pterodactyl/public/phpmyadmin && cd /var/www/pterodactyl/public/phpmyadmin
wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-english.tar.gz
tar xvzf phpMyAdmin-*-english.tar.gz
mv /var/www/pterodactyl/public/phpmyadmin/phpMyAdmin-*-english/* /var/www/pterodactyl/public/phpmyadmin
rm -rf /var/www/pterodactyl/phpMyAdmin-latest-english.tar.gz

fi


cd /var/www/pterodactyl/resources/scripts/components/server/databases
rm -rf DatabaseRow.tsx
wget https://raw.githubusercontent.com/Sigma-Production/PteroFreeStuffinstaller/V1.10.1/resources/phpmyadmin/DatabaseRow.tsx
#clear
cd /var/www/pterodactyl
yarn run build:production
#clear
php /var/www/pterodactyl/artisan up
echo "phpMyAdmin successfully installed"
