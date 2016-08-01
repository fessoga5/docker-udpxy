FROM ubuntu:14.04.2
MAINTAINER fessoga <fessoga5@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV HOME /tmp
WORKDIR /tmp

RUN apt-get update && apt-get install -y wget make gcc
RUN apt-get install -y --force-yes openssh-server openssh-client
RUN apt-get install -y --force-yes supervisor && \
	mkdir -p /var/log/supervisor && \
    	mkdir -p /var/run/sshd

RUN wget http://www.udpxy.com/download/1_23/udpxy.1.0.23-9-prod.tar.gz
RUN tar -xzvf udpxy.1.0.23-9-prod.tar.gz
RUN cd udpxy-1.0.23-9 && make && make install

ADD conf/supervisord.conf /etc/supervisor/supervisord.conf

# Create user, adding for group. Working for ssh
RUN /usr/sbin/useradd -d /home/ubuntu -s /bin/bash -p $(echo ubuntu | openssl passwd -1 -stdin) ubuntu &&\
/usr/sbin/usermod -a -G sudo ubuntu

# Add Scripts
ADD /start.sh /start.sh
RUN chmod 755 /start.sh

EXPOSE 22 8888

CMD ["/start.sh"]

