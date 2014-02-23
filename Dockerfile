# Nginx and PHP5
# http://wiki.nginx.org/
# http://us.php.net/

FROM debian:wheezy
MAINTAINER Matt Renner <matt@rennernz.com>

# Set noninteractive mode for apt-get
ENV DEBIAN_FRONTEND noninteractive

# Ensure UTF-8
RUN apt-get update
RUN apt-get -y upgrade

# Install
RUN apt-get install -y nginx \
    php5-fpm php5-mysql php-apc php5-imagick php5-imap php5-mcrypt php5-gd libssh2-php mysql-server mysql-client

RUN echo "cgi.fix_pathinfo = 0;" >> /etc/php5/fpm/php.ini
ADD nginx.conf /etc/nginx/nginx.conf
ADD https://raw.github.com/h5bp/server-configs-nginx/master/h5bp/location/protect-system-files.conf /etc/nginx/conf/protect-system-files.conf
ADD nginx-site.conf /etc/nginx/sites-available/default
RUN sed -i -e '/access_log/d' /etc/nginx/conf/expires.conf
RUN sed -i -e 's/^listen =.*/listen = \/var\/run\/php5-fpm.sock/' /etc/php5/fpm/pool.d/www.conf

# Decouple our data from our container.
VOLUME ["/data"]

EXPOSE 80
ADD start.sh /start.sh
RUN chmod +x /start.sh
ENTRYPOINT ["/start.sh"]
