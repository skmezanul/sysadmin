#!/bin/bash

###############################################################################
# Copyright 2020
# Author: Fagner Mendes
# License: GNU Public License
# Version: 1.3
# Email: fagner.mendes22@gmail.com
###############################################################################

# This script can be used to the external manual migration, it creates the emails accounts based in a file. This script is can only be used in the cPanel server for manipulated the Dovecot server instructing it a create accounts. Take care... I recommend verifying the email account in cPanel to check if the accounts were created.

echo "Starting the creation process"
sleep 5
for email in $(cat /root/listadeemails.txt) ; do uapi --user=CPANELUSER Email add_pop email=$email password=SENHA quota=0 domain=DOMINIO
echo "The email accounts was created successfully"
done

