FROM openresty/openresty:1.11.2.5-jessie

MAINTAINER heavy ruisheng <ruishenglin@126.com>

# Environment variables
ENV HOME=/data \
    INSTALL_LOG=/var/log/build.log

# Add resources
ADD resources/bin /usr/local/bin/

# Run builder
RUN chmod +x /usr/local/bin/* && touch ${INSTALL_LOG} && /bin/bash -l -c '/usr/local/bin/setup.sh build'

# Add remaining resources
RUN rm /usr/local/openresty/nginx/conf/nginx.conf
ADD resources/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf 

# Run the last bits and clean up
RUN /bin/bash -l -c '/usr/local/bin/setup.sh post_install' | tee -a ${INSTALL_LOG} > /dev/null 2>&1

EXPOSE 80

# Decouple our data from our container.
VOLUME ["/data"]

ENTRYPOINT ["/usr/local/bin/run"]
