#!/bin/bash


###############################################################################
# Copyright 2020                                                                            
# Author: Fagner Mendes                                                                      
# License: GNU Public License                                                              
# Version: 1.0                                                                                  
# Email: fagner.mendes22@gmail.com                                                      
###############################################################################

cut -f 2,5 -d : /etc/userdomains | sed '1d' | sort|uniq | sed 's/ ^  / /g' >> user.txt
for user in $( cat user.txt ) ; do uapi --user=$user Email enable_spam_assassin
echo "Successfully"
done
