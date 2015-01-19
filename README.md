# docker-nginx-php5

A Dockerfile which produces a docker image that runs [Nginx][nginx] with [PHP5][php].

[nginx]: http://wiki.nginx.org/
[php]: http://us.php.net/

## Image Creation

```
$ sudo docker build -t="combro2k/docker-nginx-php5" .
```

## Container Creation / Running

The Nginx server is configured to host a website from the `/data` folder inside the container.  You can map the container's `/data` volume to a volume on the host so the data becomes independant of the running container.

This example uses `/tmp/www` to host from, but you can modify this to your needs.

```
$ mkdir -p /tmp/www
$ sudo docker run -p 80 -v /tmp/www:/data combro2k/docker-nginx-php5
```

- /data/web: contains php files etc.
- /data/config: contains extra configuration files:
    - nginx-*.conf loaded by nginx daemon
    - php-*.conf loaded by PHP-fpm daemon
    - emstprc loaded by [esmtp][esmtp] sendmail relay for using sendmail in php mail() command

[esmtp]: http://esmtp.sourceforge.net/manual.html
