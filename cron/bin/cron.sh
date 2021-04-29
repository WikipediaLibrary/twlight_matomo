#!/bin/sh
set -e

conf_dir=/opt/cron/conf
crontabs_dir=/var/spool/cron/crontabs
www_data_crontab=${conf_dir}/www-data.crontab
root_crontab=${conf_dir}/root.crontab

for user in root www-data
do
  if  [ -f ${conf_dir}/${user}.crontab ]
  then
    cp ${conf_dir}/${user}.crontab ${crontabs_dir}/${user}
    chown root:root ${crontabs_dir}/${user}
  fi
done

apk add mariadb-client

crond -f -d 8
