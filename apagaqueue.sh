#!/bin/bash
###############################################################################
# Copyright 2020							      
#Author: Fagner Mendes							     
#License: GNU Public License						      
#Version: 1.0								      
# Email: fagner.mendes22@gmail.com					     
###############################################################################

echo "Stoping the Exim Service..."
sleep 2
/scripts/restart_srv exim --stop
echo "Preparing to delete the server queue..."
eleep 2
find /var/spool/exim/input -type f -exec rm -f {} +
echo "Initializing the Exim Server..."
/scripts/restart_srv exim --start
echo "The process was done!"
done
