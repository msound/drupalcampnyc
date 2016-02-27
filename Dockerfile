FROM php:5.6-apache

RUN a2enmod rewrite

# Install necessary packages and PHP extensions
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
    curl \
    git \
    libbz2-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng12-dev \
    libpq-dev \
    mysql-client \
    php-pear \
    unzip \
  && rm -r /var/lib/apt/lists/* \
  && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr \
  && docker-php-ext-install bz2 calendar gd mbstring mcrypt pdo pdo_mysql pdo_pgsql zip

# Install composer 
ENV COMPOSER_HOME /root/composer
ENV COMPOSER_VERSION 1.0.0-alpha10

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=${COMPOSER_VERSION}

# TODO Set memory_limit and timezone in php.ini

# Install drush
RUN composer global require drush/drush:~8.0.0@beta --prefer-dist \
  && ln -sf $COMPOSER_HOME/vendor/bin/drush.php /usr/local/bin/drush

# Add all files into container
COPY . /var/www/

# Run drush make
WORKDIR /var/www/html
RUN drush make --prepare-install ../scripts/drupal.make . \
  && cp ../scripts/settings.php sites/default/

