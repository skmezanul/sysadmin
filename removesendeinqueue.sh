#!/bin/bash

###############################################################################
# Copyright 2020							                                                
# Author: Fagner Mendes							                                          
# License: GNU Public License						                                      
# Version: 1.0								                                                  
# Email: fagner.mendes22@gmail.com					                                  
###############################################################################



echo "Please, inform the domain sender"
read domain

exiqgrep -i -f @$domain | xargs exim -Mrm
