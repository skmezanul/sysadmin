#!/bin/bash

###############################################################################
# Copyright 2020							                                                
# Author: Fagner Mendes							                                          
# License: GNU Public License						                                      
# Version: 1.0								                                                  
# Email: fagner.mendes22@gmail.com					                                  
###############################################################################

#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.

#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.

#This script generates backup only databases for all user accounts in cPanel server

echo ""

cut -d: -f2 /etc/userdomains > domain.txt
sed -i 's/ //g' domain.txt
CPUSER=$( cat /root/domain.txt )
  echo "Now processing $CPUSER ..."
for i in $CPUSER; do /scripts/pkgacct $i --skiphomedir --skipmail
done
 
