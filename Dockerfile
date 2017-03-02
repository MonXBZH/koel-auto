FROM ubuntu:16.04

MAINTAINER MonX<adm.forum.mestria@gmail.com>

# MaJ du systeme:
RUN apt-get update /
apt-get upgrade -y /
mkdir /var/koel /
cd /var/koel

# Ajout/MaJ des dependences:
RUN  apt-get install -y curl php-cli php-mbstring git unzip wget phpunit php-curl

# Ajout/MaJ de composer:
RUN wget https://getcomposer.org/composer.phar /
mv composer.phar composer /
chmod +x composer /
./composer /
mv composer /usr/local/bin /

# Ajout/MaJ MySQL:
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password $ROOT_DB_PWD'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password $ROOT_DB_PWD'
RUN apt-get install -y mysql-server
RUN service mysql start
RUN mysql -u root -p$ROOT_DB_PWD -e "CREATE DATABASE koel;"

# Ajout/MaJ de Koel:
RUN git clone https://github.com/phanan/koel
RUN cd /var/koel/koel
RUN composer install
