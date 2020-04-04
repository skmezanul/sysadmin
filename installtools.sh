#!/bin/bash

###############################################################################
#                           Copyright 2020							                      
#                        Author: Fagner Mendes							                  
#                     License: GNU Public License						                  
#                           Version: 1.0								                        
#                   Email: fagner.mendes22@gmail.com					                
###############################################################################


echo ""

echo "Prepare to install (epel-release htop atop iftop apachetop mytop nload nethogs)

for INSTALL in epel-release htop atop iftop apachetop mytop nload nethogs
do

yum install -y "$INSTALL" 2> /dev/null
done
echo "Done"

sleep 5

echo "Prepare to Disable Epel repo"
yum update --disablerepo=epel
echo "Done"
