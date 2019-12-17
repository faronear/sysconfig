apt update
apt -y install wget screen git
cd /
git clone https://github.com/teddysun/lamp.git
cd lamp
chmod 755 *.sh

read -p "Enter root password of MySQL Server: " DBPWD

./lamp.sh --apache_option 1 --db_option 3 --php_option 4 --db_manage_modules --db_root_pwd $DBPWD phpmyadmin --kodexplorer_option 1