#!/bin/bash

###############################################################################
# Copyright 2020							                                                
# Author: Fagner Mendes							                                          
# License: GNU Public License						                                      
# Version: 1.1								                                                  
# Email: fagner.mendes22@gmail.com					                                  
###############################################################################

echo ""

echo "Prepare to renane file db zone template"
cd /var/cpanel/zonetemplates/
mv /var/cpanel/zonetemplates/root_standardvirtualftp /var/cpanel/zonetemplates/root_standardvirtualftp-bkp
echo "Done"
sleep 5
clear
echo "Downloadong the new file, please wait"
wget https://raw.githubusercontent.com/fagner-fmlo/arquivos/master/root_standardvirtualftp
chmod 644 root_standardvirtualftp
clear
sleep 5
bash <( curl -s https://raw.githubusercontent.com/fagner-fmlo/sysadmin/master/createdir.sh)
echo "Done"
clear
cd /var/cpanel/perl5/lib/
wget https://raw.githubusercontent.com/fagner-fmlo/arquivos/master/Spf.pm
sleep 5
clear
echo "Prepare to install module Spf"
/usr/local/cpanel/bin/manage_hooks add module Spf
sleep 5
/scripts/upcp 2&1> /root/upcp.log
echo "Done"
