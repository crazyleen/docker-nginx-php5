FROM combro2k/debian-debootstrap:8
MAINTAINER Martijn van Maurik <docker@vmaurik.nl>

ENV HOME=/root
 
RUN export DEBIAN_FRONTEND=noninteractive && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ABF5BD827BD9BF62 && \
    echo deb http://nginx.org/packages/mainline/ubuntu trusty nginx > /etc/apt/sources.list.d/nginx-stable-trusty.list && \
    apt-get update -q && apt-get install -yq curl nginx php5-fpm php5-mysql php5-apcu php5-imagick php5-imap php5-mcrypt \
    php5-gd libssh2-php php5-memcache php5-memcached php5-curl esmtp esmtp-run && mkdir -p /etc/nginx/{sites-enabled,sites-available} /data/{bin,web,config,logs} && \
    echo "cgi.fix_pathinfo = 0;" >> /etc/php5/fpm/php.ini && sed -i -e 's/^listen =.*/listen = \/var\/run\/php5-fpm.sock/' /etc/php5/fpm/pool.d/www.conf && \
    pushd /data && curl -sS https://getcomposer.org/installer | php -- --filename=composer --install-dir=bin && popd && \
    echo "include = /data/config/php-*.conf" >> /etc/php5/fpm/pool.d/www.conf && apt-get autoremove && apt-get clean && rm -fr /var/lib/apt

# Decouple our data from our container.
VOLUME ["/data"]

# Add configs
ADD resources/etc/nginx /etc/nginx/
ADD resources/bin /usr/local/bin/

# Set execution bit
RUN chmod +x /usr/local/bin/*

EXPOSE 80

CMD ["/usr/local/bin/run"]