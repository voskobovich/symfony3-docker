FROM php:7-fpm-alpine
MAINTAINER Voskobovich Vitaly <vitaly@voskobovich.com>

# Copy PHP config
COPY ./config/php.ini /usr/local/etc/php/php.ini

# Install Symfony 3 requirements
RUN set -xe \
    # Update repository
    && apk update \
    && apk upgrade \

    # Git (need for composer)
    && apk add --no-cache git \

    # Fixed Intl version
    && apk add --no-cache libintl icu icu-dev \
    && docker-php-ext-install intl \
    && apk del icu-dev \

    && docker-php-ext-install opcache \

    # PDO
    && docker-php-ext-install pdo \

    # PDO MySQL
    && docker-php-ext-install pdo_mysql \

    # PDO PgSQL
    && apk add --no-cache postgresql-dev \
    && docker-php-ext-install pdo_pgsql \

    # Clear
    && rm -rf /tmp/* /var/cache/apk/*

# Install Composer
ONBUILD ARG GITHUB_OAUTH_TOKEN

ONBUILD RUN set -xe \
    && curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && composer config -g github-oauth.github.com $GITHUB_OAUTH_TOKEN
