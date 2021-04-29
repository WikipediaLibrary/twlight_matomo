#!/usr/bin/env sh

source /secrets.sh

dow=$( date +%a | awk '{print tolower($0)}')

echo 'Restore started'
cd /
echo 'Restoring files'
tar -xvf "/srv/matomo/backup/${1}"
echo "Dropping existing database"
#bash -c "mysql -h '${DJANGO_DB_HOST}' -u '${DJANGO_DB_USER}' -p'${DJANGO_DB_PASSWORD}' -D '${DJANGO_DB_NAME}' -e 'DROP DATABASE ${DJANGO_DB_NAME}; CREATE DATABASE ${DJANGO_DB_NAME};'" | :
mysql -h ${MATOMO_DATABASE_HOST} -u ${MATOMO_DATABASE_USERNAME} -p"${MATOMO_DATABASE_PASSWORD}" -D ${MATOMO_DATABASE_DBNAME} -e "DROP DATABASE ${MATOMO_DATABASE_DBNAME}; CREATE DATABASE ${MATOMO_DATABASE_DBNAME};"
echo "Restoring database"
mysql -h ${MATOMO_DATABASE_HOST} -u ${MATOMO_DATABASE_USERNAME} -p"${MATOMO_DATABASE_PASSWORD}" -D ${MATOMO_DATABASE_DBNAME} < /tmp/${MATOMO_DATABASE_DBNAME}.sql
echo "Cleaning up"
rm /tmp/${MATOMO_DATABASE_DBNAME}.sql
echo 'Restore complete'
