#!/bin/bash

###############################################################################
# Copyright 2020							                                                
# Author: Fagner Mendes							                                          
# License: GNU Public License						                                      
# Version: 1.0								                                                  
# Email: fagner.mendes22@gmail.com					                                  
###############################################################################


echo "Inform the sender mail"
read sendermail
echo "Inform destination mail"
read destmail

echo "Mensagem teste" | exim -r $sendermail -v -odf $destmail
