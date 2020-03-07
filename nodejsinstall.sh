#!/bin/bash

###############################################################################
# Copyright 2020							                                                
# Author: Fagner Mendes							                                          
# License: GNU Public License						                                      
# Version: 1.0								                                                  
# Email: fagner.mendes22@gmail.com					                                  
###############################################################################

# The script install Node.js for CloudLinux OS

echo "Starting the installation process of the Node.js... Please wait the process to be done!"
yum groupinstall alt-nodejs6 alt-nodejs8 alt-nodejs9 alt-nodejs10 alt-nodejs11 alt-nodejs12 --enablerepo=cloudlinux-updates-testing -y
echo "The Node.js was installed with success!"
done
