#!/bin/bash

###############################################################################
# Copyright 2020							                                                
# Author: Fagner Mendes							                                          
# License: GNU Public License						                                      
# Version: 1.2								                                                  
# Email: fagner.mendes22@gmail.com					                                  
###############################################################################

<< 'CHANGELOG'
1.1 - 03/04/2020 [Author: Fagner Mendes]
#Changes
- Was added another if to compare a another direcetory
1.2 - 18/04/2020 [Author: Fagner Mendes]
#Changes
- Removed variable DIR3
CHANGELOG

echo ""

DIR=`ls /var/cpanel/perl5/lib/`
if [ -e "/var/cpanel/perl5/lib" ]; then
echo "Directory exist"
else
echo "Directory is not exist, do you want to create it?"
read
CREATE=`mkdir -p /var/cpanel/perl5/lib/`
echo "Directory created"
fi

DIR2=`ls /usr/local/cpanel/base/root_standardvirtualftp/`
if [ -e "/usr/local/cpanel/base/root_standardvirtualftp/" ]; then
echo "Directory exist"
else
echo "Directory is not exist, do you want to create it?"
read
CREATE=`mkdir -p /usr/local/cpanel/base/root_standardvirtualftp/`
echo "Directory created"
fi

