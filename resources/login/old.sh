php /var/www/pterodactyl/artisan down
cd /var/www/pterodactyl/resources/scripts/assets/css/
rm GlobalStylesheet.ts
wget https://raw.githubusercontent.com/Sigma-Production/PteroFreeStuffinstaller/V1.10.1/resources/login/resources/scripts/assets/css/GlobalStylesheet.ts
cd /var/www/pterodactyl/resources/scripts/components/auth/
rm LoginFormContainer.tsx
wget https://raw.githubusercontent.com/Sigma-Production/PteroFreeStuffinstaller/V1.10.1/resources/login/resources/scripts/components/auth/LoginFormContainer.tsx
clear
cd /var/www/pterodactyl
yarn add react-tsparticles@1.43.1
npm i -g yarn
cd /var/www/pterodactyl
yarn install
yarn run build:production
clear
php /var/www/pterodactyl/artisan up
echo "Login animation Installed"
