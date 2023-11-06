#LABEL authors="rats4"

FROM node:21 as node
FROM php:8.2 as auditoria

#esto para que tengamos los ejecutables de node y npm supongo
COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=node /usr/local/bin/node /usr/local/bin/node
RUN ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm

COPY ./Docker/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

RUN apt-get update -y && apt-get install -y zip unzip git
#RUN docker-php-ext-install intl pdo pdo_mysql

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions pdo pdo_mysql intl

#RUN npm install -g npm
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /var/www
COPY . .

COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN groupadd auditoria
RUN useradd -ms /bin/bash rats4

ENV PORT=8000
ENTRYPOINT ["Docker/entrypoint.sh"]

#========================================================================================================
# node js commands
#FROM node:21-alpine as node

#WORKDIR /var/www
#COPY . .
#COPY package*.json ./
# i think we should only copy the package.json

#RUN npm install
#RUN npm run build
#VOLUME /var/www/node_modules





