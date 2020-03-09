#!/bin/bash
###############################################################################
# Copyright 2020							      
# Author: Fagner Mendes							     
# License: GNU Public License						      
# Version: 1.0								      
# Email: fagner.mendes22@gmail.com					     
###############################################################################

echo "Stoping the Exim Service..."
sleep 2
/scripts/restartsrv_exim --stop
echo "Preparing to delete the server queue..."
sleep 2
find /var/spool/exim/input -type f -exec rm -f {} +
echo "Starting the Exim Server..."
/scripts/restartsrv_exim --start
echo "The process was done!"

