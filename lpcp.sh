#!/bin/bash

###############################################################################
# Copyright 2020
# Author: Fagner Mendes
# License: GNU Public License
# Version: 1.1
# Email: fagner.mendes22@gmail.com
###############################################################################

#This script list the email account and change the password for a default pass


echo "Starting the list process email accounts and change passwords"
sleep 5

whmapi1 list_pops_for user=LOGINCPANEL | grep ' - ' | sed -e 's/ - //' > /root/suporte_emails.txt
for email in $(cat /root/suporte_emails.txt) ; do uapi --user=LOGINCPANEL Email passwd_pop email=$email password=SENHA domain=DOMINIO
sleep 5
done
echo "The password was changed for all accounts"


