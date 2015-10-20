#!/bin/bash

docker run -ti --rm --name docker-nginx-php5 -P combro2k/docker-nginx-php5:latest ${@}
