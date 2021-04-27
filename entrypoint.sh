#!/bin/sh
set -e

if  [ ! -n "${MATOMO_DATABASE_USERNAME+isset}" ]
then
    export MATOMO_DATABASE_USERNAME=$(cat /run/secrets/MATOMO_DATABASE_USERNAME 2>/dev/null)
fi

if  [ ! -n "${MATOMO_DATABASE_PASSWORD+isset}" ]
then
    export MATOMO_DATABASE_PASSWORD=$(cat /run/secrets/MATOMO_DATABASE_PASSWORD 2>/dev/null)
fi

if [ ! -e matomo.php ]; then
	tar cf - --one-file-system -C /usr/src/matomo . | tar xf -
	chown -R www-data:www-data .
fi

exec "$@"
