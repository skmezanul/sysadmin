#!/bin/bash


echo "Inform the cpuser"
read cpuser

find /home/$cpuser/public_html -type d -exec chmod 755 {} \;
echo "Done"

echo "Inform the cpuser"
read cpuser
find /home/$cpuser/public_html -type f -exec chmod 644 {} \; 
echo "Done"



