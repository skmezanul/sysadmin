#!/bin/bash

###############################################################################
# Copyright 2020							                                                
# Author: Fagner Mendes							                                          
# License: GNU Public License						                                      
# Version: 1.0								                                                  
# Email: fagner.mendes22@gmail.com					                                  
###############################################################################

# The script install the softaculous plugin on cpanel server

echo "adding the IPs adress to the firewall whitelist"
csf -a 216.18.221.243
csf -a 192.210.128.227
csf -a 76.164.222.115
csf -a 76.164.201.252
csf -a 148.251.68.26
cd /tmp
wget -N http://files.softaculous.com/install.sh
chmod 755 install.sh
echo "Starting the install process"
sh install.sh
echo "Done..."
