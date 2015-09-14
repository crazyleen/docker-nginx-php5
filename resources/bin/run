#!/bin/bash -e
DATADIR="/data"

[[ -d "/data/" ]] || mkdir /data
[[ -d "/data/config" ]] || mkdir /data/config
[[ -e "/data/config/nginx-default.conf" ]] || cp /etc/nginx/sites-available/default /data/config/nginx-default.conf
[[ ! -e "/data/config/php-user.ini" ]] && touch /data/config/php-user.ini
([[ -e "/data/config/php-user.ini" ]] && [[ ! -e "/etc/php5/fpm/conf.d/999-user.ini" ]]) && ln -s /data/config/php-user.ini /etc/php5/fpm/conf.d/999-user.ini
[[ -f "/data/config/esmtprc" ]] || cp /etc/esmtprc /data/config/esmtprc
[[ ! -L "/etc/esmtprc" ]] && rm /etc/esmtprc && ln -s /data/config/esmtprc /etc/esmtprc
[[ -d "/data/web" ]] || mkdir /data/web
[[ -d "/data/logs" ]] || mkdir /data/logs

chown www-data: /data -R

service php5-fpm start
chmod 666 /var/run/php5-fpm.sock
/usr/sbin/nginx
