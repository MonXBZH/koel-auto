FROM ubuntu:16.04

MAINTAINER MonX<adm.forum.mestria@gmail.com>

# MaJ du systeme:
RUN apt-get update
&& apt-get upgrade -y
&& mkdir /var/koel
&& cd /var/koel

# Ajout/MaJ des dependences:
RUN  apt-get install -y curl php-cli php-mbstring git unzip wget

# Ajout/MaJ de composer:
RUN wget https://getcomposer.org/composer.phar
&& mv composer.phar composer
&& chmod +x composer
&& ./composer
&& mv composer /usr/local/bin

# Add the start script
ADD start.sh /tmp/start.sh
RUN chmod 755 /tmp/start.sh
VOLUME ["/data"]
EXPOSE 64738

CMD ["/tmp/start.sh"]
