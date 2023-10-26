#LABEL authors="rats4"

FROM php:8.2 as auditoria

RUN apt-get update -y && apt-get install -y openssl zip unzip git
#RUN docker-php-ext-install intl pdo pdo_mysql

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions pdo pdo_mysql intl

WORKDIR /var/www
COPY . .

COPY --from=composer /usr/bin/composer /usr/bin/composer
ENV PORT=8000
ENTRYPOINT ["docker/entrypoint.sh"]

#========================================================================================================
# node js commands
FROM node:21-alpine as node

WORKDIR /var/www
COPY . .

RUN npm install
VOLUME /var/www/node_modules




