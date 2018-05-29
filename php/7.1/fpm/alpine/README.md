Docker Image PHP packages for Symfony 3 Framework based on Alpine Linux
===

This repository contains source files for the Docker Image PHP containers for Symfony 3 Framework based on **Alpine Linux**.  

Images from this repository, solve only **basic PHP requirements for Symfony 3**. There is nothing superfluous!  

For check requirements, run the following command in your container:
```bash
php bin/symfony_requirements
```

See my [Docker Hub page](https://hub.docker.com/u/voskobovich).


## Supported tags

Respective Dockerfile links:

1. `7.1.0-fpm-alpine`, `7.1-fpm-alpine`, `7-fpm-alpine`, `fpm-alpine` ([7.1/fpm/alpine/Dockerfile](https://github.com/voskobovich/symfony3-docker/blob/master/php/7.1/fpm/alpine/Dockerfile))


## How use?

Create a new `Dockerfile` with this content

```dockerfile
FROM voskobovich/symfony3-php:7-fpm-alpine

RUN chmod -R 774 /root /root/.composer

WORKDIR /var/www/html

COPY ./app ./

RUN set -xe \
 && chown -R operator:root ./

USER operator

RUN set -xe \
 && composer install --prefer-dist --no-dev
```

The user "operator" are necessary for the maintenance of the project with "composer".

and add new service in your `docker-compose.yml` file

```yaml
version: '2'
services:
  php:
    build:
      context: <path to folder with Dockerfile>
      args:
        - GITHUB_OAUTH_TOKEN=<your GitHub token>
    container_name: php
    volumes:
      - <path to your symfony project root>:/var/www/html
```

or use `docker build` command

```bash
cp /path/to/your/dockerfile
docker build -t symfony3-php:personal-edition --build-arg GITHUB_OAUTH_TOKEN=<your GitHub token> .
```

## These packages can be useful to you.

The following examples show the configuration of your `Dockerfile`.


### For install GD

Create a new `Dockerfile` with this content

```dockerfile
FROM voskobovich/symfony3-php:7-fpm-alpine

RUN set -xe \
    # Update repository
    && apk update \
    && apk upgrade \

    # Add packages to compile the libraries
    && apk add --no-cache autoconf g++ libtool make \

    # GD
    && apk add --no-cache freetype-dev libjpeg-turbo-dev libxml2-dev libpng-dev \
    && docker-php-ext-configure gd \
        --with-gd \
        --with-freetype-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \

    # Clear after install GD
    && apk del --no-cache freetype-dev libjpeg-turbo-dev libxml2-dev \

    # Clear
    && apk del --no-cache autoconf g++ libtool make \
    && rm -rf /tmp/* /var/cache/apk/*
```


### For install ImageMagic

Create a new `Dockerfile` with this content

```dockerfile
FROM voskobovich/symfony3-php:7-fpm-alpine

RUN set -xe \
    # Update repository
    && apk update \
    && apk upgrade \

    # Add packages to compile the libraries
    && apk add --no-cache autoconf g++ libtool make \

    # ImageMagic
    && apk add --no-cache imagemagick-dev \
    && pecl install imagick \
    && docker-php-ext-enable imagick \

    # Clear
    && apk del --no-cache autoconf g++ libtool make \
    && rm -rf /tmp/* /var/cache/apk/*
```


### For install Memcached

Create a new `Dockerfile` with this content

```dockerfile
FROM voskobovich/symfony3-php:7-fpm-alpine

RUN set -xe \
    # Update repository
    && apk update \
    && apk upgrade \

    # Memcached
    && apk add --no-cache libmemcached-dev zlib-dev cyrus-sasl-dev \
    && docker-php-source extract \
    && git clone --branch php7 https://github.com/php-memcached-dev/php-memcached.git /usr/src/php/ext/memcached/ \
    && docker-php-ext-configure memcached \
    && docker-php-ext-install memcached \
    && docker-php-source delete \
    && apk del --no-cache zlib-dev cyrus-sasl-dev \

    # Clear
    && rm -rf /tmp/* /var/cache/apk/*
```
