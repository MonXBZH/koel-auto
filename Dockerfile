FROM ubuntu:16.04

MAINTAINER MonX<adm.forum.mestria@gmail.com>

# Variables:
ENV MYSQL_USER=mysql \
  MYSQL_DATA_DIR=/var/lib/mysql \
  MYSQL_RUN_DIR=/run/mysqld \
  MYSQL_LOG_DIR=/var/log/mysql \
  DEBIAN_FRONTEND=noninteractive

# Ports exposés:
EXPOSE 3306/tcp

# MaJ du systeme:
RUN set -x \
  && apt-get update \
  && apt-get upgrade -y \

# Ajout/MaJ des dependences:
RUN  apt-get install -y curl php-cli php-mbstring git unzip wget phpunit php-curl

# Ajout/MaJ de composer:
RUN wget https://getcomposer.org/composer.phar \
  && mv composer.phar composer \
  && chmod +x composer \
  && ./composer \
  && mv composer /usr/local/bin

# Ajout/MaJ MySQL:
CMD echo "mysql-server mysql-server/root_password password rootmdp" | sudo debconf-set-selections
CMD echo "mysql-server mysql-server/root_password_again password rootmdp" | sudo debconf-set-selections
CMD apt-get install -y mysql-server \
  && rm -rf ${MYSQL_DATA_DIR} \
  && rm -rf /var/lib/apt/lists/* \
  && service mysql start \
  && mysql -u root -e "CREATE DATABASE koel;"
VOLUME ["${MYSQL_DATA_DIR}", "${MYSQL_RUN_DIR}"]
CMD ["/usr/bin/mysqld_safe"]

# Ajout/MaJ de Koel:
CMD git clone https://github.com/phanan/koel \
 && cd /var/koel/koel \
 && composer install
