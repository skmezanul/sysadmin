#!/bin/bash


###############################################################################
# Copyright 2020                                                                            
# Author: Fagner Mendes                                                                      
# License: GNU Public License                                                              
# Version: 1.0                                                                                  
# Email: fagner.mendes22@gmail.com                                                      
###############################################################################


echo ""


echo "Inform the cpuser"
read cpuser
echo "Inform the reason (e.g - Nonpayment, consuming lots of resources, sending spam"
read reason
whmapi1 suspendacct user=$cpuser reason=$reason disallowun=1 leave-ftp-accts-enabled=0

echo ""

echo "The 'cpuser' was suspended successfully"
