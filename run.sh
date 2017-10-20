#!/bin/bash

docker run -ti --rm --name docker-nginx-php5 -P gzlrs/docker-nginx-php5:latest ${@}
