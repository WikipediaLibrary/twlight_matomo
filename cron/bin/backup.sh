#!/usr/bin/env sh

source /secrets.sh

dt=$( date +'%Y-%m-%d-%H-%M' )

echo 'Backup Started'
# Cleanup any previous db dump
rm /tmp/${MATOMO_DATABASE_DBNAME}.sql 2>/dev/null || :
## Perform db dump
mysqldump -h ${MATOMO_DATABASE_HOST} -u ${MATOMO_DATABASE_USERNAME} -p"${MATOMO_DATABASE_PASSWORD}" ${MATOMO_DATABASE_DBNAME} > /tmp/${MATOMO_DATABASE_DBNAME}.sql
# Root only
chmod 0600 /tmp/${MATOMO_DATABASE_DBNAME}.sql
# Create tarball
tar -czf /srv/matomo/backup/${MATOMO_FQDN}.${dt}.tar.gz -P /var/www/html/config/config.ini.php /var/www/html/plugins /tmp/${MATOMO_DATABASE_DBNAME}.sql
# Cleanup db dump
rm /tmp/${MATOMO_DATABASE_DBNAME}.sql
echo 'Backup Complete'
