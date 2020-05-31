#!/bin/bash

###############################################################################
# Copyright 2020							                                                
# Author: Fagner Mendes							                                          
# License: GNU Public License						                                      
# Version: 1.0								                                                  
# Email: fagner.mendes22@gmail.com					                                  
###############################################################################

echo ""

echo "Prepare to install EA customization, since 5.4 to 7.3 and any extensions"
mkdir -p /etc/cpanel/ea4/profiles/custom/
cd /etc/cpanel/ea4/profiles/custom/
wget https://raw.githubusercontent.com/fagner-fmlo/arquivos/master/ea-custom.json
echo "Install now, please wait...!"
sleep 5
/usr/local/bin/ea_install_profile --install /etc/cpanel/ea4/profiles/custom/ea-custom.json >> /root/easyapacheinstall.log
echo "Done..."
clear


cd /opt/cpanel/ea-php56/root/etc/
mv php.ini php.ini-bkp
wget https://raw.githubusercontent.com/fagner-fmlo/arquivos/master/ea.5.6-php.ini
mv ea.5.6-php.ini php.ini


cd /opt/cpanel/ea-php70/root/etc/
mv php.ini php.ini-bkp
wget https://raw.githubusercontent.com/fagner-fmlo/arquivos/master/ea.7.0-php.ini
mv ea.7.0-php.ini php.ini


cd /opt/cpanel/ea-php71/root/etc/
mv php.ini php.ini-bkp
wget https://raw.githubusercontent.com/fagner-fmlo/arquivos/master/ea.7.1-php.ini
mv ea.7.1-php.ini php.ini


cd /opt/cpanel/ea-php72/root/etc/
mv php.ini php.ini-bkp
wget https://raw.githubusercontent.com/fagner-fmlo/arquivos/master/ea.7.2-php.ini
mv ea.7.2-php.ini php.ini


cd /opt/cpanel/ea-php73/root/etc/
mv php.ini php.ini-bkp
wget https://raw.githubusercontent.com/fagner-fmlo/arquivos/master/ea.7.3-php.ini
mv ea.7.3-php.ini php.ini


cd /opt/cpanel/ea-php74/root/etc/
mv php.ini php.ini-bkp
wget https://raw.githubusercontent.com/fagner-fmlo/arquivos/master/ea.7.4-php.ini
mv ea.7.4-php.ini php.ini
