#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password vagrant'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password vagrant'

sudo apt-get update

sudo apt-get install -y software-properties-common python-software-properties

sudo add-apt-repository -y ppa:ondrej/php5-5.6

sudo apt-get update

sudo apt-get install -y php5 php5-xdebug php5-mysql apache2 mysql-server curl

sudo cp /vagrant/provision/config/xdebug.ini /etc/php5/mods-available/xdebug.ini

sudo a2enmod rewrite
sudo a2enmod mime
sudo a2enmod deflate
sudo a2enmod filter

sudo sed -i 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf

sudo service apache2 restart

curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

cd /var/www/html

if [ ! -f index.html ]; then
	sudo rm index.html
fi
if [ ! -f settings.php ]; then
	cp default.settings.php settings.php
	sed -i 's/_DB_USER_/root/g' settings.php
	sed -i 's/_DB_PASSWORD_/vagrant/g' settings.php
fi

composer install

mysql -uroot -pvagrant -e "CREATE DATABASE IF NOT EXISTS emoncms"

if [ ! -f /var/log/emoncms.log ]; then
	sudo touch /var/log/emoncms.log
	sudo chmod 666 /var/log/emoncms.log
fi