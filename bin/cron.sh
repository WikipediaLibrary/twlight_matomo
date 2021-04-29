#!/bin/sh
set -e

cp /tmp/www-data.crontab /var/spool/cron/crontabs/www-data
chown root:root /var/spool/cron/crontabs/www-data
crond -f -d 8
