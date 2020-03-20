#!/bin/bash

###############################################################################
# Copyright 2020							                                                
# Author: Fagner Mendes							                                          
# License: GNU Public License						                                      
# Version: 1.0								                                                  
# Email: fagner.mendes22@gmail.com					                                  
###############################################################################

echo "Starting the update server"
yum update -y
echo "Done..."

/scripts/upcp --force
echo "Done"

echo "Prepare to install PostgreSLQ"
/scripts/installpostgres
echo "Done"

sleep 2

echo "Setting default mail catching"
sed -i s/defaultmailaction=fail/defaultmailaction=fail/g' /var/cpanel/cpanel.config
echo "Done"

sleep 2

echo "Configuring security policies"
sed -i 's/SecurityPolicy::PasswordStrength=0/SecurityPolicy::PasswordStrength=1/g' /var/cpanel/cpanel.config
echo "Done"

sleep 2

echo "Disable functions on Apache"
sed -i 's/TraceEnable ON/TraceEnable Off/g' /etc/apache2/conf/httpd.conf
sed -i 's/ServerTokens ProductOnly/ServerTokens ProductOnly/g' /etc/apache2/conf/httpd.conf
sed -i 's/FileETag None/FileETag None/g' /etc/apache2/conf/httpd.conf
apachectl graceful
echo "Done"

sleep 2

echo "Disable functions to Pure-FTPD"
sed -i 's/NoAnonymous no/NoAnonymous yes/g' /etc/pure-ftpd.conf
sed -i 's/PassivePortRange 49152 65534/PassivePortRange 30000 50000/g' /etc/pure-ftpd.conf
sed -i 's/AnonymousCantUpload no/AnonymousCantUpload yes/g' /etc/pure-ftpd.conf
/scripts/restartsrv_ftpd --restart
echo "Done..."
sleep 2

echo "Disabling GCC - Compilers"
chmod 750 /usr/bin/gcc

