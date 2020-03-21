#!/bin/bash

###############################################################################
# Copyright 2020							                                                
# Author: Fagner Mendes							                                          
# License: GNU Public License						                                      
# Version: 1.1								                                                  
# Email: fagner.mendes22@gmail.com					                                  
###############################################################################


package-cleanup --dupes | tail -n +3 > duplist.txt
cat duplist.txt | sort --version-sort | awk 'NR % 2 {print "rpm -e --justdb --nodeps " $1 } !(NR % 2) {match($0, "-[0-9]");print "yum -y reinstall " substr($0,0,RSTART-1)}'
set timeout 360
#expect "Do you want to continue?" { send "\r" }
echo "Starting the process to solve this issue, please wait!"
cat duplist.txt | sort --version-sort | awk 'NR % 2 {print "rpm -e --justdb --nodeps " $1 } !(NR % 2) {match($0, "-[0-9]");print "yum -y reinstall " substr($0,0,RSTART-1)}' | sh

