FROM richarvey/nginx-php-fpm:latest

LABEL maintainer="Ric Harvey <ric@squarecows.com>"

ENV php_conf /usr/local/etc/php-fpm.conf
ENV fpm_conf /usr/local/etc/php-fpm.d/www.conf
ENV php_vars /usr/local/etc/php/conf.d/docker-vars.ini

ENV LUAJIT_LIB=/usr/lib
ENV LUAJIT_INC=/usr/include/luajit-2.1

# resolves #166
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

RUN apk del openssh-client
RUN apk add --no-cache openssh

ADD scripts/start.sh /start.sh
RUN chmod +x /start.sh

# openssh conf
RUN echo "Port 2222" >> /etc/ssh/sshd_config && \
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
echo "root:Docker!" | /usr/sbin/chpasswd



EXPOSE 443 80 2222

WORKDIR "/var/www/html"
CMD ["/start.sh"]
