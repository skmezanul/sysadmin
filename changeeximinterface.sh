#!/bin/bash

###############################################################################
# Copyright 2020							                                                
# Author: Fagner Mendes							                                          
# License: GNU Public License						                                      
# Version: 1.0								                                                  
# Email: fagner.mendes22@gmail.com					                                  
###############################################################################


echo ""

echo "Prepare to stop exim service"
/scripts/restartsrv_exim --stop
echo "Inform the ipaddress"
read ipaddress
sed -i 's/interface =.*/interface = $ipaddress/g' /etc/exim.conf
sed -i 's/helo_data =.*/helo_data = ndns30524.dizinc.com/g' /etc/exim.conf
/scripts/buildeximconf
/scripts/restartsrv_exim --start
echo "Done"
