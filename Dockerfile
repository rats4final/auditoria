FROM node:21 as node
FROM php:8.2 as auditoria

LABEL authors="rats4"
USER root

RUN groupadd -r auditgroup && useradd -r -g auditgroup rats4
RUN chown -R rats4:auditgroup /var/www/
RUN mkdir /home/rats4
RUN chown -R rats4:auditgroup /home/rats4

#esto para que tengamos los ejecutables de node y npm supongo
COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=node /usr/local/bin/node /usr/local/bin/node
RUN ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm

COPY Docker/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

RUN apt-get update -y && apt-get install -y zip unzip git
#RUN docker-php-ext-install intl pdo pdo_mysql

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions pdo pdo_mysql intl

RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#USER rats4
WORKDIR /var/www
COPY . .
RUN chmod +x ./Docker/entrypoint.sh
RUN chown rats4:auditgroup /usr/local/bin/entrypoint.sh
COPY --from=composer /usr/bin/composer /usr/bin/composer
#USER rats4

ENV PORT=8000
ENTRYPOINT ["entrypoint.sh"]