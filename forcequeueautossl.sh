#!/bin/bash

###############################################################################
# Copyright 2020							                                                
# Author: Fagner Mendes							                                          
# License: GNU Public License						                                      
# Version: 1.0								                                                  
# Email: fagner.mendes22@gmail.com					                                  
###############################################################################

# This script force the queue autossl

echo "Starting the force... Pleas wait!"
/usr/local/cpanel/bin/autossl_check_cpstore_queue --force
exit 0
echo $exit
if [ $exit == 0 ] then
echo "The force was done with success!"
done
