#!/bin/bash

export DEBIAN_FRONTEND=noninteractive 
export PACKAGES=(
	'php5-fpm'
	'php5-mysql'
  'php5-redis'
  'php5-mongo'
	'php5-apcu'
	'php5-imagick'
	'php5-imap'
	'php5-intl'
	'php5-mcrypt'
	'php5-gd'
	'libssh2-php'
	'php5-memcache'
	'php5-memcached'
	'php5-curl'
	'esmtp'
	'esmtp-run'
)

pre_install(){
  echo 'deb http://mirrors.aliyun.com/debian/ jessie main non-free contrib' > /etc/apt/sources.list
  echo 'deb http://mirrors.aliyun.com/debian/ jessie-proposed-updates main non-free contrib' >> /etc/apt/sources.list
  echo 'deb-src http://mirrors.aliyun.com/debian/ jessie main non-free contrib' >> /etc/apt/sources.list
  echo 'deb-src http://mirrors.aliyun.com/debian/ jessie-proposed-updates main non-free contrib' >> /etc/apt/sources.list

    apt-get update -q 2>&1
    apt-get install -yq ${PACKAGES[@]} 2>&1

    sources=(
        '/data/bin'
        '/data/web'
        '/data/config'
        '/data/logs'
	)

    mkdir -vp ${sources[@]} 2>&1
}

configure_php5_fpm()
{
    echo "cgi.fix_pathinfo = 0;" >> /etc/php5/fpm/php.ini
    sed -i -e 's/^listen =.*/listen = \/var\/run\/php5-fpm.sock/' /etc/php5/fpm/pool.d/www.conf
    echo "include = /data/config/php-*.conf" >> /etc/php5/fpm/pool.d/www.conf
}

configure_nginx_openstar()
{
    rm -f /usr/local/openresty/nginx/conf/*
    cp /opt/openresty/openstar/conf/* /usr/local/openresty/nginx/conf/
}

post_install() {
    apt-get autoremove 2>&1
    apt-get autoclean 2>&1
    rm -fr /var/lib/apt 2>&1
}

build() {
	if [ ! -f "${INSTALL_LOG}" ]
	then
		touch "${INSTALL_LOG}"
	fi

	tasks=(
		'pre_install'
		'configure_php5_fpm'
    'configure_nginx_openstar'
	)

	for task in ${tasks[@]}
	do
		echo "Running build task ${task}..."
		${task} | tee -a "${INSTALL_LOG}" > /dev/null 2>&1 || exit 1
	done
}

if [ $# -eq 0 ]
then
	echo "No parameters given! (${@})"
	echo "Available functions:"
	echo

	compgen -A function

	exit 1
else
	for task in ${@}
	do
		echo "Running ${task}..."
		${task} || exit 1
	done
fi
