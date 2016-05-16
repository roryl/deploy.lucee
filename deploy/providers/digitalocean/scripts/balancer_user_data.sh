#!/bin/bash
yum -y install httpd
systemctl enable httpd
apachectl start
adduser balancer
echo "balancer:{{password}}" | chpasswd
usermod -d /home/balancer
chown -R balancer:balancer /home/balancer
echo "balancer ALL=(ALL) ALL" >> /etc/sudoers
mkdir /home/balancer/bin
touch /home/balancer/bin/updatelb.sh
chmod 777 /home/balancer/bin/updatelb.sh