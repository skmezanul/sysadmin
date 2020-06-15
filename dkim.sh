#!/bin/ash

for user in `cat /etc/localdomains | cut -d" " -f2 | sort| uniq`; do /usr/local/cpanel/bin/dkim_keys_install $user > /dev/null 2>&1 ; done ; rm -rf /var/spool/exim/input/*
