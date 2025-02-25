FROM debian

# Set up LLMP server
RUN apt-get update && apt-get upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y lighttpd php-cgi php-mysql unzip mariadb-server mariadb-client
RUN lighttpd-enable-mod fastcgi
RUN lighttpd-enable-mod fastcgi-php
RUN rm /var/www/html/index.lighttpd.html

# Install LWT
#COPY lwt_v_1_6_1.zip /tmp/lwt.zip
ADD https://github.com/HugoFara/lwt/archive/refs/tags/2.5.2.zip /tmp/lwt.zip
RUN cd /var/www/html && unzip /tmp/lwt.zip && mv lwt-2.5.2/* . && rm -rf lwt-2.5.2/ && rm /tmp/lwt.zip 
RUN printf '<?php\n$server = "%s";\n$userid = "%s";\n$passwd = "%s";\n$dbname = "%s";\n?>' "localhost" "root" "abcxyz" "learning-with-texts" > /var/www/html/connect.inc.php
RUN chmod -R 755 /var/www/html

EXPOSE 80

CMD /etc/init.d/mariadb start && /etc/init.d/lighttpd start && sleep infinity

# docker built -t lwt .
# docker run -it -p 8010:80 lwt
