apt update
apt -y install wget screen git
cd /
git clone https://github.com/teddysun/lamp.git
cd lamp
chmod 755 *.sh

echo "LAMP https://lamp.sh"
echo "Don't select php 7.2 or above, it fails due to lacking of freetype-config. Please use php 7.1"
read -p "Enter root password of MySQL Server >> " DBPWD

screen ./lamp.sh --apache_option 1 --db_option 3 --php_option 7 --db_root_pwd $DBPWD --db_manage_modules phpmyadmin --kodexplorer_option 1
