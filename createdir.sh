#!/bin/bash

###############################################################################
# Copyright 2020							                                                
# Author: Fagner Mendes							                                          
# License: GNU Public License						                                      
# Version: 1.1								                                                  
# Email: fagner.mendes22@gmail.com					                                  
###############################################################################

<< 'CHANGELOG'
1.1 - 03/04/2020 [Author: Fagner Mendes]
#Changes
- Was added another if to compare a another direcetory
CHANGELOG

echo ""

DIR=`ls /var/cpanel/perl5/lib/`
if [ -e "/var/cpanel/perl5/lib" ]; then

echo "Directory exist"
else
echo "Directory is not exist, do you want to create it?"
read
CRIATE=`mkdir /var/cpanel/perl5/lib/`
echo "Directory created"
fi

DIR2=`ls /usr/local/cpanel/base/root_standardvirtualftp/`
if [ -e "/usr/local/cpanel/base/root_standardvirtualftp/" ]; then
echo "Directory exist"
else
echo "Directory is not exist, do you want to create it?"
read
CRIATE=`mkdir -p /usr/local/cpanel/base/root_standardvirtualftp/`
echo "Directory created"
fi

DIR3=`ls /var/cpanel/perl5/lib/`
if [ -e "/var/cpanel/perl5/lib/" ]; then
echo "Directory exist"
else
echo "Directory is not exist, do you want to create it?"
read
CRIATE=`mkdir -p /var/cpanel/perl5/lib/`
echo "Directory created"
fi
