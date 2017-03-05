#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password vagrant'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password vagrant'

sudo apt-get update

sudo apt-get install -y software-properties-common python-software-properties

sudo add-apt-repository -y ppa:ondrej/php5-5.6

sudo apt-get update

sudo apt-get install -y php5 php5-xdebug php5-mysql apache2 mysql-server curl php-pear php5-dev redis-server

sudo pear channel-discover pear.swiftmailer.org
sudo pecl install channel://pecl.php.net/dio-0.0.6 redis swift/swift

sudo sh -c 'echo "extension=dio.so" > /etc/php5/apache2/conf.d/20-dio.ini'
sudo sh -c 'echo "extension=dio.so" > /etc/php5/cli/conf.d/20-dio.ini'
sudo sh -c 'echo "extension=redis.so" > /etc/php5/apache2/conf.d/20-redis.ini'
sudo sh -c 'echo "extension=redis.so" > /etc/php5/cli/conf.d/20-redis.ini'

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

if [ ! -f composer.json ]; then
	composer install
fi

mysql -uroot -pvagrant -e "CREATE DATABASE IF NOT EXISTS emoncms"

if [ ! -f /var/log/emoncms.log ]; then
	sudo touch /var/log/emoncms.log
	sudo chmod 666 /var/log/emoncms.log
fi
