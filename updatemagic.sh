#!/bin/bash

###############################################################################
# Copyright 2020							                                                
# Author: Fagner Mendes							                                          
# License: GNU Public License						                                      
# Version: 1.0								                                                  
# Email: fagner.mendes22@gmail.com					                                  
###############################################################################

# This script update the magicspam plugin

echo "Starting the update... Please Wait!"
eleep 2
/usr/share/magicspam/bin/package-updater -o -a > /tmp/updatemagic.log | mail -s "MagicSpam" suporte@servhost.com.br
echo "The Update was Done!"
done
