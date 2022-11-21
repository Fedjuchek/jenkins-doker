FROM alpine

ENV TZ=Europe/Kiev
 
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    apk update && \
    apk add apache2 php7 php7-fpm php7-opcache && \
    rm -rf /var/www/localhost/htdocs/index.html

COPY src/index.php /var/www/localhost/htdocs
     
EXPOSE 80

CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
