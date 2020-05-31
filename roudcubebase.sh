#!/bin/bash

###############################################################################
# Copyright 2020							                                                
# Author: Fagner Mendes							                                          
# License: GNU Public License						                                      
# Version: 1.1								                                                  
# Email: fagner.mendes22@gmail.com					                                  
###############################################################################

# This script verify the roundcube database is sqllite or mysql, for migration is necessary that servers has the same database.

<< 'CHANGELOG'
1.1 - 01/04/2020 [Author: Fagner Mendes, help from Felipe Rangel]
#Changes
- Reformulatiion of script

CHANGELOG

echo ""


ROUNDCUBE=`/usr/bin/grep -i roundcube_db /var/cpanel/cpanel.config`
if [ "${ROUNDCUBE}" == "${ROUNDCUBE}" ]; then
       echo "DB is Sqlite, nothing to do"
    else
        echo "Prepare to convert from mysql to sqlite"
/usr/local/cpanel/scripts/convert_roundcube_mysql2sqlite
echo "Done"
    fi
