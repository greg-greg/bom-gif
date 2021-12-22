FROM php:7.4-cli

# make sure apt is up to date
RUN apt-get update --fix-missing
RUN apt-get install -y curl

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd
	
#install some base extensions
RUN apt-get install -y \
        libzip-dev \
        zip \
  && docker-php-ext-install zip
  
RUN mkdir /var/www/public
RUN cd /var/www/public

COPY composer.json /var/www/public/composer.json

WORKDIR /var/www/public

RUN apt-get update && apt-get install -y git
#RUN git clone  --progress --verbose https://github.com/caseyfw/bom-gif.git /var/www/public \
	#&& ls \
	#&& pwd \
	#&& curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
#RUN cd /var/www/public/bom-gif

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN composer install --no-scripts --no-autoloader --no-interaction

	


CMD [ "php", "./index.php" ]