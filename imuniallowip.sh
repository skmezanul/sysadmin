#!/bin/bash

###############################################################################
# Copyright 2020							                                                
# Author: Fagner Mendes							                                          
# License: GNU Public License						                                      
# Version: 1.0								                                                  
# Email: fagner.mendes22@gmail.com					                                  
###############################################################################

echo ""

echo "Inform the ipaddress"
read ipaddress
echo "Inform the comment"
imunify360-agent whitelist ip add $ipaddress --comment "$comment"
echo "Done"
