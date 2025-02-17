FROM php:7.4.4-cli

MAINTAINER Flo Flo contact.magician@gmail.com

# Install required system packages
RUN apt-get update && \
    apt-get -y install \
            git \
            zlib1g-dev \
            libssl-dev \
            libzip-dev \
            unzip \
        --no-install-recommends && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install php extensions
RUN docker-php-ext-install \
    bcmath \
    zip

# Install pecl extensions
RUN pecl install \
        mongodb \
        apcu \
        xdebug-2.9.4 && \
    docker-php-ext-enable \
        apcu.so \
        mongodb.so \
        xdebug

# Configure php
RUN echo "date.timezone = UTC" >> /usr/local/etc/php/php.ini

# Install composer
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN curl -sS https://getcomposer.org/installer | php -- \
        --filename=composer \
        --install-dir=/usr/local/bin
RUN composer global require --prefer-dist --no-interaction --optimize-autoloader --apcu-autoloader \
        "hirak/prestissimo"

# Prepare application
WORKDIR /repo

# Prepare host-volume working directory
RUN mkdir /project
WORKDIR /project
