# Dockerfile for moodle instance. more dockerish version of https://github.com/sergiogomez/docker-moodle
FROM ubuntu:17.04
MAINTAINER Burcin Baykan <burcinbaykan1986@gmail.com>

VOLUME ["/var/moodledata"]
EXPOSE 80 443
COPY moodle-config.php /var/www/html/config.php

# Keep upstart from complaining
# RUN dpkg-divert --local --rename --add /sbin/initctl
# RUN ln -sf /bin/true /sbin/initctl

# Let the container know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

#Moodle Info

ENV MOODLE_ADMIN eledia
ENV MOODLE_ADMIN_PASSWORD Eledia28!
ENV MOODLE_ADMIN_EMAIL bb@eledia.de



# Database info
ENV MYSQL_HOST 127.0.0.1
ENV MYSQL_USER moodle
ENV MYSQL_PASSWORD moodle
ENV MYSQL_DB moodle
#ENV MOODLE_URL http://130.149.22.217



COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh



# ADD http://downloads.sourceforge.net/project/moodle/Moodle/stable27/moodle-latest-27.tgz /tmp/moodle-latest-27.tgz
ADD ./foreground.sh /etc/apache2/foreground.sh

RUN apt-get update && \
	apt-get -y install mysql-client php7.0-soap php7.0-zip php7.0-mbstring php7.0-xml php7.0-cli php7.0-ldap pwgen python-setuptools curl git unzip apache2 php7.0 \
		php7.0-gd libapache2-mod-php7.0 postfix wget supervisor php7.0-pgsql curl libcurl3 \
		libcurl3-dev php7.0-curl php7.0-xmlrpc php7.0-intl php7.0-mysql git-core && \
	cd /tmp && \
	git clone -b MOODLE_32_STABLE git://git.moodle.org/moodle.git --depth=1 && \
	mv /tmp/moodle/* /var/www/html/ && \
	rm /var/www/html/index.html && \
	chown -R www-data:www-data /var/www/html && \
	chmod +x /etc/apache2/foreground.sh

# Enable SSL, moodle requires it
RUN a2enmod ssl && a2ensite default-ssl # if using proxy, don't need actually secure connection


# Cleanup
RUN apt-get clean autoclean && apt-get autoremove -y && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/lib/dpkg/* /var/lib/cache/* /var/lib/log/*

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["/etc/apache2/foreground.sh"]

#RUN easy_install supervisor
#ADD ./start.sh /start.sh
#ADD ./install_database.php /var/www/html/install_database.php 
#RUN chmod 755 /var/www/html/install_database.php 
#RUN ls -Lilah
#RUN /usr/bin/php /var/www/html/install_database.php --lang=de --adminuser=adminuser --adminpass=12Moodle# --adminemail=burcin@mailbox.tu-berlin.de --fullname=Testseite --shortname=host     --agree-license
#ADD ./supervisord.conf /etc/supervisord.conf
# RUN chmod 755 /start.sh /etc/apache2/foreground.sh
# EXPOSE 22 80
# CMD ["/bin/bash", "/start.sh"]
#RUN -id   /usr/bin/php  /var/www/html/admin/cli/install_database.php
