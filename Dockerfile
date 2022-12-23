FROM php:8.0.26-fpm-alpine

RUN apk add --no-cache nginx wget

RUN mkdir -p /run/nginx

COPY docker/nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /app
COPY . /app

RUN docker-php-ext-install pdo pdo_mysql

RUN sh -c "wget http://getcomposer.org/composer.phar && chmod a+x composer.phar && mv composer.phar /usr/local/bin/composer"

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/

RUN install-php-extensions zip

# RUN cd /app && \
#     /usr/local/bin/composer --ignore-platform-req=ext-gd

RUN chown -R www-data: /app

CMD sh /app/docker/startup.sh