#!/bin/bash
# ENVIROMENT = default_value
# ALIAS: "www.irknet.ru"
# NAME: "irknet.ru"  
# HTTPS: True
# SSL: True
# REPO: ssh://git@gitlab01.core.irknet.lan:7777/irknet/irknet.git
# PATH: /home/www/irknet.ru
# PASSWORD: ubuntu

# Disable Strict Host checking for non interactive git clones

if [ ! -z "$PASSWORD" ] ; then
	# Change password for user ubuntu
	echo "ubuntu:${PASSWD}" | /usr/sbin/chpasswd
fi

# Start syslog
/usr/sbin/rsyslogd

# Setting's udpxy
# OPTIONS
#
#   udpxy accepts the following options:

#   A -a <listenaddr>
#   	IPv4 address/interface to listen on [default = 0.0.0.0].
#   M -m <mcast_ifc_addr>
#   	IPv4 address/interface of (multicast) source [default = 0.0.0.0].
#   C -c <clients>
#   	Maximum number of clients to accept [default = 3, max = 5000].
#   -l <logfile>
#   	Log output to file [default = stderr].
#   B -B <sizeK>
#   	Buffer size (65536, 32Kb, 1Mb) for inbound (multicast) data [default = 2048 bytes].
#   -R <msgs>
#   	Maximum number of messages to buffer (-1 = all) [default = 1].
#   -H <sec>
#   	Maximum time (in seconds) to hold data in a buffer (-1 = unlimited) [default = 1].
#   -n <nice_incr>
#   	Nice value increment [default = 0].
#   -M <sec>
#   	Renew multicast subscription every M seconds (skip if 0) [default = 0].
#   P -p <port>
#   	Port to listen on.
# Default line:
# /usr/local/sbin/udpxy -a A -m M -p P -S -B B -c C
A_ENV=${A:="eth0"}
M_ENV=${M:="eth0"}
P_ENV=${P:="8888"}
B_ENV=${B:="2048K"}
C_ENV=${C:="10"}

sed -i.bak 's/-a A/-a '"$A_ENV"'/g' /etc/supervisor/supervisord.conf
sed -i.bak 's/-m M/-a '"$M_ENV"'/g' /etc/supervisor/supervisord.conf
sed -i.bak 's/-p P/-p '"$P_ENV"'/g' /etc/supervisor/supervisord.conf
sed -i.bak 's/-B B/-B '"$B_ENV"'/g' /etc/supervisor/supervisord.conf
sed -i.bak 's/-c C/-c '"$C_ENV"'/g' /etc/supervisor/supervisord.conf


# Start supervisord and services
/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
