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
whmapi1 unsuspendreseller user=$cpuser reseller-only=0
echo "Done"
