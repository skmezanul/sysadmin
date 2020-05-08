#!/bin/bash

###############################################################################
# Copyright 2020
# Author: Fagner Mendes
# License: GNU Public License
# Version: 1.4
# Email: fagner.mendes22@gmail.com
###############################################################################

<< 'CHANGELOG'
1.4 - 08 de maio/2020 [Author: Fagner Mendes]
#Changes
- Set variable for cpuser, pass and domain
CHANGELOG


# This script can be used to the external manual migration, it creates the emails accounts based in a file. This script is can only be used in the cPanel server for manipulated the Dovecot server instructing it a create accounts. Take care... I recommend verifying the email account in cPanel to check if the accounts were created.

echo ""

echo "Starting the creation process, first creat the file /root/listadeemails.txt and inserted the login mail accounts line below line"
echo "Inform the cpuser"
read cpuser
echo "Inform the default password"
read pass
echo "Inform the domain"
read domain
for email in $(cat /root/listadeemails.txt) ; do uapi --user=$cpuser Email add_pop email=$email password=$pass quota=0 domain=$domain
echo "The email accounts was created successfully"
done

