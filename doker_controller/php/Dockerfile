# ------------------------------------------------------------
# Image d’exécution PHP 8.4 avec Apache — platforme multiple
# ------------------------------------------------------------
FROM --platform=$BUILDPLATFORM php:8.4-apache

# --- Apache : FQDN silencieux -------------------------------------------------
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# --- Dépendances système + Node 20 + Yarn 4 + outils de build -----------------
RUN apt-get update && apt-get install -y --no-install-recommends \
        # Paquets usuels
        locales git acl unzip zip \
        # Librairies pour extensions PHP
        libicu-dev libpng-dev libxml2-dev libzip-dev libonig-dev libxslt-dev \
        # Toolchain pour compiler certains paquets npm (node-gyp / Rust)
        build-essential python3 rustc cargo \
    && echo "en_US.UTF-8 UTF-8"  > /etc/locale.gen \
    && echo "fr_FR.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen \
    # --- NodeSource 20 LTS ----------------------------------------------------
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    # --- Corepack → Yarn stable ----------------------------------------------
    && corepack enable && corepack prepare yarn@stable --activate \
    # --- Extensions PHP -------------------------------------------------------
    && docker-php-ext-configure intl \
    && docker-php-ext-install            \
          pdo pdo_mysql gd opcache       \
          intl zip calendar dom mbstring xsl \
    && pecl install apcu \
    && docker-php-ext-enable apcu \
    # --- Nettoyage couche -----------------------------------------------------
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# --- Composer & Symfony CLI ---------------------------------------------------
RUN curl -sSk https://getcomposer.org/installer | php -- --disable-tls \
    && mv composer.phar /usr/local/bin/composer \
    && curl -sS https://get.symfony.com/cli/installer | bash \
    && mv /root/.symfony*/bin/symfony /usr/local/bin/symfony

# --- Apache : réécriture et VirtualHost racine --------------------------------
RUN a2enmod rewrite
WORKDIR /var/www
RUN sed -i 's!/var/www/html!/var/www!g' /etc/apache2/sites-enabled/000-default.conf

# --- Copie du projet ----------------------------------------------------------
# Place ton .dockerignore pour exclure node_modules, vendor, .git, etc.
COPY --chown=www-data:www-data . /var/www

# --- Script d’entrée (optionnel) ---------------------------------------------
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh


# Pour résoudre les problémes de wsl (car windows est en  nfts  et linux en ext4)
RUN git config --system --add safe.directory /var/www/app


ENTRYPOINT ["/entrypoint.sh", "apache2-foreground"]
