#!/bin/sh

set -e

CONTAINER_INIT_DIR="/container.init"
if [ -d $CONTAINER_INIT_DIR ]
then
    find $CONTAINER_INIT_DIR -name *.sh -exec chmod a+x {} \;
    find $CONTAINER_INIT_DIR -name *.sh -exec {} \;
fi

CONF_FILE=/usr/local/etc/php-fpm.d/www.conf

if [ ! -z ${PM_MAX_CHILDREN+x} ]; then
    sed -ie "s|^pm\.max_children =.*$|pm\.max_children = ${PM_MAX_CHILDREN}|g" $CONF_FILE
fi

if [ ! -z ${PM_START_SERVERS+x} ]; then
    sed -ie "s|^pm\.start_servers =.*$|pm\.start_servers = ${PM_START_SERVERS}|g" $CONF_FILE
fi

if [ ! -z ${PM_MIN_SPARE_SERVERS+x} ]; then
    sed -ie "s|^pm\.min_spare_servers =.*$|pm\.min_spare_servers = ${PM_MIN_SPARE_SERVERS}|g" $CONF_FILE
fi

if [ ! -z ${PM_MAX_SPARE_SERVERS+x} ]; then
    sed -ie "s|^pm\.max_spare_servers =.*$|pm\.max_spare_servers = ${PM_MAX_SPARE_SERVERS}|g" $CONF_FILE
fi

if [ ! -z ${PM_MAX_REQUESTS+x} ]; then
  sed -ie "s|^pm\.max_requests =.*$|pm\.max_requests = ${PM_MAX_REQUESTS}|g" $CONF_FILE
fi

CONF_FILE=/usr/local/etc/php-fpm.d/zz-docker.conf

if [ ! -z ${PM_LISTEN+x} ]; then
  sed -ie "s|^listen = 9000$|listen = ${PM_LISTEN}|g" $CONF_FILE
fi

if [ -S "$DOCKER_SOCK" ]; then
  echo docker.sock = $DOCKER_SOCK
  GROUP_ID_DOCKER=`getent group docker | cut -d: -f3`
  FILE_GROUP_ID=`stat -c %g /var/run/docker.sock`

  if [ "$GROUP_ID_DOCKER" != "$FILE_GROUP_ID" ];
  then
     grep -qw ^docker /etc/group && groupdel docker
     groupadd --gid $FILE_GROUP_ID docker
  fi

  usermod -a -G docker $FPM_USER
fi

exec "$@"