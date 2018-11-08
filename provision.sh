#!/usr/bin/env bash


# Environment Laravel original provisioning script
# https://github.com/dung13890

# Update Package List
apt-get update
apt-get install -y software-properties-common locales

locale-gen en_US.UTF-8

echo "LANGUAGE=en_US.UTF-8" >> /etc/default/locale
echo "LC_ALL=en_US.UTF-8" >> /etc/default/locale
echo "LC_CTYPE=UTF-8" >> /etc/default/locale

export LANG=en_US.UTF-8

# PPA
apt-add-repository ppa:ondrej/php -y

# Install PHP-CLI 7, some PHP extentions
apt-get update
apt-get install -y --force-yes \
    php7.2-cli \
    php7.2-dev \
    php7.2-common \
    php7.2-curl \
    php7.2-json \
    php7.2-soap \
    php7.2-xml \
    php7.2-mbstring \
    php7.2-mysql \
    php7.2-pgsql \
    php7.2-sqlite \
    php7.2-sqlite3 \
    php7.2-zip \
    php7.2-gd \
    php7.2-xdebug \
    php7.2-bcmath \
    php7.2-intl \
    php7.2-dev \
    php7.2-fpm \
    php-pear \
    php-memcached \
    php-redis \
    php-apcu \
    libcurl4-openssl-dev \
    libedit-dev \
    libssl-dev \
    libxml2-dev \
    xz-utils \
    sqlite3 \
    libsqlite3-dev \
    libmcrypt-dev \
    libreadline-dev \
    git \
    curl \
    vim \
    zip \
    unzip \
    supervisor

# Installing mcrypt on PHP 7.2
printf "\n" | pecl install mcrypt-1.0.1
bash -c "echo extension=mcrypt.so > /etc/php/7.2/mods-available/mcrypt.ini"

# Remove load xdebug extension
sed -i 's/^/;/g' /etc/php/7.2/cli/conf.d/20-xdebug.ini

# Set php7.2-fpm
sed -i "s/listen =.*/listen = 0.0.0.0:9000/" /etc/php/7.2/fpm/pool.d/www.conf
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.2/fpm/php.ini
sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.2/fpm/php.ini
sed -i "s/post_max_size = .*/post_max_size = 50M/" /etc/php/7.2/fpm/php.ini
sed -i "s/upload_max_filesize = .*/upload_max_filesize = 50M/" /etc/php/7.2/fpm/php.ini
mkdir -p /var/run/php
mkdir -p /var/log/php-fpm
touch /var/run/php/php7.2-fpm.sock

# Install Composer, PHPCS
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
composer global require "squizlabs/php_codesniffer=*"

# Create symlink
ln -s /root/.composer/vendor/bin/phpcs /usr/bin/phpcs

# Install Nodejs
curl -sL https://deb.nodesource.com/setup_8.x | bash -
apt-get install -y nodejs
npm install -g bower

# Install yarn
curl -s https://dl.yarnpkg.com/debian/pubkey.gpg -o /tmp/yarn-pubkey.gpg
apt-key add /tmp/yarn-pubkey.gpg && rm /tmp/yarn-pubkey.gpg
echo 'deb http://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list
apt-get update && apt-get install yarn

# Clean up
apt-get clean && apt-get autoclean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
