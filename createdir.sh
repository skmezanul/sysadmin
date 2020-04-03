#!/bin/bash

###############################################################################
# Copyright 2020							                                                
# Author: Fagner Mendes							                                          
# License: GNU Public License						                                      
# Version: 1.0								                                                  
# Email: fagner.mendes22@gmail.com					                                  
###############################################################################


DIR=`ls /var/cpanel/perl5/lib/`
if [ -e "/var/cpanel/perl5/lib" ]; then

echo "Directory exist"
else
echo "Directory is not exist, do you want to create it?"
read
CRIA=`mkdir /var/cpanel/perl5/lib/`
echo "Directory created"
fi
