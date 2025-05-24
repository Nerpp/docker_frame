FROM --platform=$BUILDPLATFORM php:8.2-apache

# Évite l’avertissement FQDN
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Dépendances + extensions + ACL
RUN apt-get update && apt-get install -y --no-install-recommends \
        locales git acl \
        libicu-dev g++ libpng-dev libxml2-dev libzip-dev \
        libonig-dev libxslt-dev \
 && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
 && echo "fr_FR.UTF-8 UTF-8" >> /etc/locale.gen \
 && locale-gen \
 && docker-php-ext-configure intl \
 && docker-php-ext-install pdo pdo_mysql gd opcache intl zip calendar dom mbstring xsl \
 && pecl install apcu \
 && docker-php-ext-enable apcu \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Composer & Symfony CLI
RUN curl -sSk https://getcomposer.org/installer | php -- --disable-tls && mv composer.phar /usr/local/bin/composer
RUN curl -sS https://get.symfony.com/cli/installer | bash && mv /root/.symfony*/bin/symfony /usr/local/bin/symfony

# Apache
RUN a2enmod rewrite
WORKDIR /var/www

RUN sed -i 's!/var/www/html!/var/www!g' /etc/apache2/sites-enabled/000-default.conf

# Copie du projet (contexte = racine) + droits
COPY --chown=www-data:www-data . /var/www

# Script d’entrée
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh", "apache2-foreground"]