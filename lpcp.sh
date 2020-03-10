#!/bin/bash

###############################################################################
# Copyright 2020							                                                
# Author: Fagner Mendes							                                          
# License: GNU Public License						                                      
# Version: 1.0								                                                  
# Email: fagner.mendes22@gmail.com					                                  
###############################################################################

#This script list the email account and change the password for a default pass


echo "Starting the list process email accounts and change passwords"
sleep 5

uapi list_pops --user=LOGINCPANEL | grep ' - ' | sed -e 's/ - //' > /root/LOGIN_emails.txt
for email in $(cat /root/LOGIN_emails.txt) ; do uapi --user=contacpanel Email passwd_pop email=$email password=senha domain=dominiodacontas ; do
sleep 5

echo "The password was changed for all accounts"
