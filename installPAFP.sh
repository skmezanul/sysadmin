#!/bin/bash

###############################################################################
# Copyright 2020							                                                
# Author: Fagner Mendes							                                          
# License: GNU Public License						                                      
# Version: 1.3								                                                  
# Email: fagner.mendes22@gmail.com					                                  
###############################################################################

echo ""

echo "Stating the update in the system"
apt-get update; apt-get upgrade -y
echo "The update was done"
echo "Starting installation Postgres in the system"
apt install postgresql postgresql-contrib -y
echo "Postgres was installed in the system"

echo ""

echo "Starting installation Apache2"
apt install apache2 -y
echo "Apache2 was installed in the system"
echo "Stating the install process repos PHP"
apt install software-properties-common -y
echo "Done!"

echo ""

echo "Set the PPA"
LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php
echo "Starting the installation PHP 7.3"
apt install php7.3 php7.3-cli php7.3-common -y
echo "Done!"

echo ""

echo "Starting process stallation PHP extesions"
apt install php-pear php7.3-curl php7.3-dev php7.3-gd php7.3-mbstring php7.3-zip php7.3-xml php7.3-fpm libapache2-mod-php7.3 php7.3-imagick php7.3-recode php7.3-tidy php7.3-xmlrpc php7.3-intl php-pgsql php3-pgsql php7.0-pgsql php7.3-pgsql php7.4-pgsql -y
echo "Done!"

echo ""

echo "Enabling the pdo module"
a2enmod php3-pgsql
echo "The module was enable"
sleep 5
echo "Starting the stallation of vsftpd"
apt install vsftpd -y
echo "Done!"

echo ""

sleep 5

echo "Starting services"
systemctl enable apache2
systemctl start apache2
systemctl enable  postgresql
systemctl start  postgresql
systemctl enable vsftpd
systemctl start vsftpd
echo "The services vsftpd apache2 postgres was started"
echo "done"


echo "Prepare to rename vsftpd.conf
mv /etc/vsftpd.conf /etc/vsftpd.conf-orig
cd /etc/
wget https://raw.githubusercontent.com/fagner-fmlo/arquivos/master/vsftpd.conf
chmod 644 vsftpd.conf
chown root.root vsftpd.conf
systemctl restart vsftpd.service
echo "Done"

echo "Prepare to rename apache2.conf"
mv /etc/apache2/apache2.conf /etc/apache2/apache2.conf-orig
cd /etc/apache2/
wget https://raw.githubusercontent.com/fagner-fmlo/arquivos/master/apache2.conf
chmod 644 apache2.conf
chown root.root. apache2.conf
a2enmod rewrite
apachectl restart
echo "Done"


echo "Prepare to rename files postgresql"
mv /etc/postgresql/10/main/postgresql.conf /etc/postgresql/10/main/postgresql.conf-orig
mv /etc/postgresql/10/main/pg_hba.conf /etc/postgresql/10/main/pg_hba.conf-orig
cd /etc/postgresql/10/main/
wget https://raw.githubusercontent.com/fagner-fmlo/arquivos/master/postgresql.conf
wget https://raw.githubusercontent.com/fagner-fmlo/arquivos/master/pg_hba.conf
chmod 644 postgresql.conf
chmod 640 pg_hba.conf
chown postgres.postgres postgresql.conf
chown postgres.postgres pg_hba.conf
systemctl restart postgresql.service
echo "Done"


echo "Prepare to create ftp user"
read user
useradd $user -b /var/www/html/
echo "Prepare to set password"
read user
passwd $user
echo "Done"


echo "Prepare to create a postgres user"
read user
createuser -a -d -E -P $user
echo "Done"


echo "Prepare to rename the files permission - TCP Wrapper"
cd /etc
mv hosts.allow hosts.allow-bkp 
mv hosts.deny hosts.deny-bkp
echo "Done..."

sleep 5

echo "Downlowding the new files, please wait..."
wget http://arquivos.servhost.com.br/hosts.allow --http-user=romero --http-passwd=servhost84@!
wget http://arquivos.servhost.com.br/hosts.deny --http-user=romero --http-passwd=servhost84@!
echo "Done..."

sleep 5

echo "Setting new permissions"
chmod 644 /etc/hosts.allow
chmod 644 /etc/hosts.deny
echo "Done..."
clear


echo "Prepare to changes the options in the SSHD"
sed -i 's/Port 1891/Port 1865/g' /etc/ssh/sshd_config
echo "Protocol 2" >> /etc/ssh/sshd_config
sed -i 's/PermitRootLogin yes/PermitRootLogin without-password/g' /etc/ssh/sshd_config
sed -i 's/#UseDNS yes/UseDNS no/g' /etc/ssh/sshd_config
sed -i '21d' /etc/ssh/sshd_config
/scripts/restartsrv_sshd --restart
echo "Done..."



