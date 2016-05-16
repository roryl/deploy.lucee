#!/usr/bin/expect
set username [lindex $argv 0];
set password [lindex $argv 1];
set host [lindex $argv 2];
set addRem [lindex $argv 3];
set IP [lindex $argv 4];
spawn echo "$username"
spawn echo "$password"
spawn echo "$host"
spawn echo "$addRem"
spawn echo "$IP"
interact