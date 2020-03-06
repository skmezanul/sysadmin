#!/bin/bash

#Author: Fagner Mendes
#License: GNU Public License
#Version: 1.0
#This is script is used to create subfolders into maildirbox
#The most important is active the that subfolders in webmails clients, (Ex: Horde, RoundCube)

#Take care, change the "user" on the flag in the first line: (Ex: user=suporte), should be currently the cPanel user on the system.
whmapi1 list_pops_for user=suporte | grep ' - ' | sed -e 's/ - //' > /root/emails.txt
EMAIL=$( cat /root/emails.txt )
for loop in $EMAIL; do
for i in $( cat /root/emails.txt ) ; do doveadm mailbox create -u $loop -s INBOX.quarentena ; done 2> /dev/null
done
