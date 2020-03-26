#!/bin/bash

###############################################################################
# Copyright 2020							                                                
# Author: Fagner Mendes							                                          
# License: GNU Public License						                                      
# Version: 1.6					                                                  
# Email: fagner.mendes22@gmail.com					                                  
###############################################################################

echo "Prepare to install yum utils package"
yum install yum-utils -y
clear
package-cleanup --dupes | tail -n +3 > duplist.txt
cat duplist.txt | sort --version-sort | awk 'NR % 2 {print "rpm -e --justdb --nodeps " $1 } !(NR % 2) {match($0, "-[0-9]");print "yum -y reinstall " substr($0,0,RSTART-1)}'
echo "Do you want to continue? Presse <ENTER> to continue..."
read
echo "Starting the process to solve this issue, please wait!"
cat duplist.txt | sort --version-sort | awk 'NR % 2 {print "rpm -e --justdb --nodeps " $1 } !(NR % 2) {match($0, "-[0-9]");print "yum -y reinstall " substr($0,0,RSTART-1)}' | sh
yum clean all
yum update > /root/yumupdate.log
rm -f duplist.txt
rm -f rpd.sh
clear
