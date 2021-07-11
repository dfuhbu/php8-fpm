#!/bin/bash
set -e

FPM_LISTEN=127.0.0.1:9000

if [ ! -z ${PM_LISTEN+x} ]; then
  FPM_LISTEN=${PM_LISTEN}
fi

SCRIPT_NAME=/fpm-ping SCRIPT_FILENAME=/fpm-ping REQUEST_METHOD=GET cgi-fcgi -bind -connect $FPM_LISTEN | egrep pong
exit $?
