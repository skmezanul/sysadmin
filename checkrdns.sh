#!/bin/bash

###############################################################################
# Copyright 2020							                                                
# Author: Fagner Mendes							                                          
# License: GNU Public License						                                      
# Version: 1.0								                                                  
# Email: fagner.mendes22@gmail.com					                                  
###############################################################################


#This script is a loop for massive querys of rDNS

echo ""

IPS=$( cat host.txt )
for i in $IPS; do dig -x $i +short
done
