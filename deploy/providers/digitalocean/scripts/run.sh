#!/usr/bin/expect
set username [lindex $argv 0];
set password [lindex $argv 1];
set host [lindex $argv 2];
set addRem [lindex $argv 3];
set IP [lindex $argv 4];
spawn ssh-keygen -R "$host"
spawn ssh -t -oStrictHostKeyChecking=no $username@$host "echo /home/balancer/bin/updatelb.sh $addRem $IP | sudo bash"
expect "assword"
send "$password\r"
expect "assword"
send "$password\r"
interact