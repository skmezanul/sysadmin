#!/bin/bash

###############################################################################
# Copyright 2020							                                                
# Author: Fagner Mendes							                                          
# License: GNU Public License						                                      
# Version: 1.0								                                                  
# Email: fagner.mendes22@gmail.com					                                  
###############################################################################
# This script verify the roundcube database is sqllite or mysql, for migration is necessary that servers has the same database.
grep -i roundcu /var/cpanel/cpanel.config
