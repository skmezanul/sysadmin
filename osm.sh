#!/bin/bash

###############################################################################
# Copyright 2020							                                                
# Author: Fagner Mendes							                                          
# License: GNU Public License						                                      
# Version: 1.0								                                                  
# Email: fagner.mendes22@gmail.com					                                  
###############################################################################


echo ""

echo "Starting install"

yum install libpcap libpcap-devel
cd /usr/src
wget https://download.configserver.com/osminstaller.tgz
tar -xzf osminstaller.tgz
perl osminstaller.pl ipv4
rm -fv osminstaller.*
echo "Done"
