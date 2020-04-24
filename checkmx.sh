#!/bin/bash

###############################################################################
# Copyright 2020							                                                
# Author: Fagner Mendes							                                          
# License: GNU Public License						                                      
# Version: 1.0								                                                  
# Email: fagner.mendes22@gmail.com					                                  
###############################################################################


#This script is a loop for massive check MX

echo ""

MX=$( cat /root/host.txt )
for i in $MX; do host $i
done
