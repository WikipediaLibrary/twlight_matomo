#!/bin/sh
set -e

crontab=/tmp/www-data.crontab

if  [ -f "${crontab}" ]
then
  cp /tmp/www-data.crontab /var/spool/cron/crontabs/www-data
  chown root:root /var/spool/cron/crontabs/www-data
fi

apk add mariadb-client

crond -f -d 8
