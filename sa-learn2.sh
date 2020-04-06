#!/bin/bash

###############################################################################
# Copyright 2020							                                                
# Author: Fagner Mendes							                                          
# License: GNU Public License						                                      
# Version: 1.0								                                                  
# Email: fagner.mendes22@gmail.com					                                  
###############################################################################

# This script do the search in all mail boxe and reports to the SA learn what is spam


echo ""

#Prepare to reset the informations SA"
/usr/local/cpanel/3rdparty/bin/sa-learn --clear
/usr/local/cpanel/3rdparty/bin/sa-learn --sync
echo "Done"
clear

echo ""

echo "Prepare to start SA to all accounts in the server"
/usr/local/cpanel/3rdparty/bin/sa-learn -p /home/*/.spamassassin/user_prefs --use-ignores --spam /home/*/mail/*/*/.spam/{cur,new}
echo " The process was done"

echo ""

clear

