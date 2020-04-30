#!/bin/bash

###############################################################################
# Copyright 2020							                                                
# Author: Fagner Mendes							                                          
# License: GNU Public License						                                      
# Version: 1.0								                                                  
# Email: fagner.mendes22@gmail.com					                                  
###############################################################################

echo ""

user=$(pwd | cut -d/ -f3) 
wget https://downloads.joomla.org/br/cms/joomla3/3-9-16/Joomla_3-9-16-Stable-Full_Package.zip?format=zip 
unzip Joomla_3-9-16-Stable-Full_Package.zip?format=zip
bash <( curl -s https://raw.githubusercontent.com/fagner-fmlo/sysadmin/master/fixcpperm.sh)
find $user -type f -exec chown $user.$user {} +
rm -rf Joomla_3-9-16-Stable-Full_Package.zip?format=zip
echo -e "\033[01;35mSay Hello to Brazil"
