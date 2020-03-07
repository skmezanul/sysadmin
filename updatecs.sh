#!/bin/bash
###############################################################################
# Copyright 2020							     
#Author: Fagner Mendes							      
#License: GNU Public License						     
#Version: 1.0								      
# Email: fagner.mendes22@gmail.com
###############################################################################

# This script update the configserver plugins

echo "Starting the update process..."
sleep 2
curl -s download.configserver.com/csupdate | perl > /tmp/update-configserver.txt
echo "The configserver plugin was updated!"
done
