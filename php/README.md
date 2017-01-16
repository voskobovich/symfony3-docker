Docker Image PHP packages for Symfony 3 Framework 
===

This repository contains source files for the Docker Image PHP containers for Symfony 3 Framework.

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
FROM voskobovich/yii2-php:7-fpm-alpine

RUN chmod -R 774 /root /root/.composer

WORKDIR /var/www/html

COPY ./source ./

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
