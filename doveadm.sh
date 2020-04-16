#!/bin/bash

###############################################################################
# Copyright 2020                                                                            
# Author: Fagner Mendes                                                                      
# License: GNU Public License                                                              
# Version: 1.1                                                                                  
# Email: fagner.mendes22@gmail.com                                                      
###############################################################################

<< 'CHANGELOG'
1.1 - 16 de abril/2020 [Author: Fagner Mendes]
#Changes
- Add variable to read the cpuser

CHANGELOG



echo ""


# This is script is used to create subfolders into maildirbox
# The most important is active the that subfolders in webmails clients, (Ex: Horde, RoundCube)

# Take care, change the "user" on the flag in the first line: (Ex: user=suporte), should be currently the cPanel user in the system.
echo "Inform the cpuser"
read cpuser
whmapi1 list_pops_for user=$cpuser | grep ' - ' | sed -e 's/ - //' > /root/emails.txt
EMAIL=$( cat /root/emails.txt )
for loop in $EMAIL; do
for i in $( cat /root/emails.txt ) ; do doveadm mailbox create -u $loop -s INBOX.quarentena ; done 2> /dev/null
done
