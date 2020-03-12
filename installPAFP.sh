#!/bin/bash

###############################################################################
# Copyright 2020							                                                
# Author: Fagner Mendes							                                          
# License: GNU Public License						                                      
# Version: 1.1								                                                  
# Email: fagner.mendes22@gmail.com					                                  
###############################################################################

echo "Stating the update in the system"
apt-get update; apt-get upgrade -y
echo "The update was done"
echo "Starting installation Postgres in the system"
apt install postgresql postgresql-contrib -y
echo "Postgres was installed in the system"

echo "Starting installation Apache2"
apt install apache2 -y
echo "Apache2 was instaled in the system"
echo "Stating the install process repos PHP"
apt install software-properties-common -y
echo "Done!"
echo "Set the PPA"
LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php
echo "Starting the installation PHP 7.3"
apt install php7.3 php7.3-cli php7.3-common y
echo "Done!"
echo Starting process stallation PHP extesions"
apt install php-pear php7.3-curl php7.3-dev php7.3-gd php7.3-mbstring php7.3-zip php7.3-mysql php7.3-xml php7.3-fpm libapache2-mod-php7.3 php7.3-imagick php7.3-recode php7.3-tidy php7.3-xmlrpc php7.3-intl php-pgsql php3-pgsql -y
echo "Done!"
echo "Enabling the pdo module"
a2enmod php3-pgsql
echo "The module was enable"
sleep 5
echo "Starting the stallation of vsftpd"
apt install vsftpd -y
echo "Done!"

sleep 5
echo "Starting services"
systemctl enable apache2
systemctl start apache2
systemctl enable  postgresql
systemctl start  postgresql
systemctl enable vsftpd
systemctl start vsftpd
echo "The services vsftpd apache2 postgres was started"
done
