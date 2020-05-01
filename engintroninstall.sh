#!/bin/bash 

echo ""

echo "Prepare to install Engintron in this server"

cd /  
rm -f engintron.sh  
wget --no-check-certificate https://raw.githubusercontent.com/engintron/engintron/master/engintron.sh  
bash engintron.sh install
