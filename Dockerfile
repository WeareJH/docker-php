#
# PHP 7 FPM Magento EE Compatible - Stripped back.
#
# Credits
#     Mark Shust <mark.shust@mageinferno.com> for starting point
#     Nick Jones <nick@nicksays.co.uk> for improvements / ideas
#

FROM php:7-fpm
MAINTAINER Michael Woodward <michael@wearejh.com>

RUN apt-get update \
  && apt-get install -y \
    cron \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng12-dev \
    libxslt1-dev \
    gettext

RUN docker-php-ext-configure \
  gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

RUN docker-php-ext-install \
  gd \
  intl \
  mbstring \
  mcrypt \
  pdo_mysql \
  xsl \
  zip \
  soap \
  bcmath

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Xdebug
RUN pecl install -o -f xdebug-2.4.0

ADD bin/docker-configure /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-configure

ADD bin/magento-install /usr/local/bin/
RUN chmod +x /usr/local/bin/magento-install

ADD etc/xdebug.template /usr/local/etc/php/conf.d/php-xdebug.template
ADD etc/php.template /usr/local/etc/php/conf.d/php-custom.template

ENTRYPOINT ["/usr/local/bin/docker-configure"]
CMD ["php-fpm"]
