&& apt-get --no-install-recommends -qq -y install zlib1g libmemcached11 libpq5 libmemcachedutil2 \
&& aptitude install --without-recommends  -y --add-user-tag forbuildonly zlib1g-dev libpq-dev libmemcached-dev \
# Composer
&& curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
# DB opcache
&& docker-php-ext-install opcache mysqli pgsql \
# Igbinary
&& pecl install igbinary \
&& docker-php-ext-enable igbinary \
# Memcached
&& echo "no --disable-memcached-sasl\n" | pecl install memcached \
&& docker-php-ext-enable memcached \
#