FROM viliusl/ubuntu-sshd-nginx:latest

MAINTAINER Vilius Lukosius <vilius.lukosius@gmail.com>

# make sure the package repository is up to date
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

# install java
RUN apt-get install -y openjdk-7-jre-headless unzip wget

# set-up h2
RUN wget http://www.h2database.com/h2-2014-01-18.zip
RUN unzip h2-2014-01-18.zip -d /opt/
ADD h2/h2-server.sh /opt/h2/bin/h2-server.sh
RUN chmod +x /opt/h2/bin/h2-server.sh
ADD h2/h2-conf /opt/h2-conf
RUN mkdir -p /opt/h2-data
RUN rm h2-2014-01-18.zip

# update nginx
ADD nginx/index.html        /var/www/index.html

# configure supervisor
ADD supervisor/h2.conf   		/etc/supervisor/conf.d/h2.conf

#clean-up
RUN apt-get clean

#h2 tcp, nginx, h2 console, sshd
EXPOSE 1521 80 81 22

CMD ["/usr/bin/supervisord", "-n"]