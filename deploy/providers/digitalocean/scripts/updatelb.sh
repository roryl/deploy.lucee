#!/bin/bash
if [ "$#" -ne 2 ];
then
    printf "You must enter exactly 2 command line arguments:\n\n    updatelb r 192.168.1.3\n\n    updatelb a 192.168.1.1\n"
    exit 1
fi

if [ "$1" = "a" ]
then
    cat /etc/httpd/conf/httpd.conf | sed '/\#BalancerMembers.*$/a\\                \BalancerMember 'http\:\/\/$2\:80'' > /tmp/httpd.conf
    mv /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.bak
    mv /tmp/httpd.conf /etc/httpd/conf/httpd.conf
    /sbin/apachectl configtest
    /sbin/apachectl graceful
fi
if [ "$1" = "r" ]
then
    ip=${2//./\\.}
    cat /etc/httpd/conf/httpd.conf | sed "/$ip/d" > /tmp/httpd.conf
    mv /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.bak
    mv /tmp/httpd.conf /etc/httpd/conf/httpd.conf
    /sbin/apachectl configtest
    /sbin/apachectl graceful
fi