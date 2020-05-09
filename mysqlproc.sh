#!/bin/bash

###############################################################################
# Copyright 2020                                                                            
# Author: Fagner Mendes                                                                      
# License: GNU Public License                                                              
# Version: 1.1                                                                                  
# Email: fagner.mendes22@gmail.com                                                      
###############################################################################

echo ""


mysqladmin proc | grep "Waiting for table level lock" > /root/mysqlproc.txt
MYSQLPROC=$( cat /root/mysqlproc.txt )
for loop in $MYSQLPROC; do
for i in $( cat /root/mysqlproc.txt ) ; do mysqladmin proc $loop ; done
done

