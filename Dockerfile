FROM  php:8.0.8-fpm-buster

ENV TZ=UTC
ENV FPM_USER=fpm

COPY files/php-ext.ini /usr/local/etc/php/conf.d/php-ext.ini
COPY files/zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf
COPY files/*.sh /

RUN DEBIAN_FRONTEND=noninteractive \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
    # Error dir
    && mkdir /tmp/error/ \
    && chmod a+w /tmp/error/ \
    && chmod a+x /*.sh \
    #
    && apt-get update \
    && apt-get --no-install-recommends -qq -y install vim aptitude libfcgi-bin curl \
    #
    INCLUDE(docker-php-extension.sh)
    INCLUDE(docker-pinba.sh)
    #
    && groupadd -g 1008 $FPM_USER \
    && useradd -u 1008 -g 1008 $FPM_USER \
    #
    && aptitude purge -y '?user-tag(forbuildonly)' \
    && docker-php-source delete \
    && apt-get -y remove aptitude python3 \
    && apt-get -y autoremove \
    && rm -rf /soft/ \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /www/
ENTRYPOINT ["/run.sh"]
CMD ["php-fpm"]

HEALTHCHECK --interval=2m --timeout=3s CMD /healthcheck.sh
