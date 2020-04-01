#!/bin/bash

###############################################################################
# Copyright 2020							                                                
# Author: Fagner Mendes							                                          
# License: GNU Public License						                                      
# Version: 1.0								                                                  
# Email: fagner.mendes22@gmail.com					                                  
###############################################################################

<< 'CHANGELOG'

1.1 - 01/04/2020 [Author: Fagner Mendes]
#Changes
- Change the functions (Disable functions, change permissions, )

CHANGELOG

echo ""


echo "Starting the update server"
yum update -y
echo "Done..."

/scripts/upcp --force

sed -i 's/IPADDR=216.120.234.31/IPADDR=216.120.234.31/g' /etc/sysconfig/network-scripts/ifcfg-ens3


echo "Prepare to disable functions in the server"
for SERVICE in autofs cups nfslock rpcidmapd rpcidmapd bluetooth anacron hidd pcscd avahi-daemon
do
        service "$SERVICE" stop > /dev/null 2>&1
        chkconfig "$SERVICE" off > /dev/null 2>&1
done
echo "Done..."
clear
sleep 5

echo "Prepare to changes the permission files"
for FILES1 in /usr/bin/rcp /usr/bin/rcp /usr/bin/lynx /usr/bin/links /usr/bin/scp /usr/bin/gcc
do

chmod 750 "$FILES1" > /dev/null 2>&1
done

for FILES2 in /etc/httpd/proxy/ /var/spool/samba/ /var/mail/vbox/
do

chmod 000 "$FILES2" > /dev/null 2>&1
done

echo "Done"

clear

echo "Install DNS Check"

cd ~
wget http://download.ndchost.com/accountdnscheck/latest-accountdnscheck
sh latest-accountdnscheck
echo "Done..."

sleep 5

echo "Adding script remove"
echo "30 23 * * * sh /root/remover.sh" >> /var/spool/cron/root
chmod 755 /root/remover.sh
echo "Done..."

sleep 5

echo "Runnig the fix quotas"
/scripts/fixquotas
echo "Done..."

sleep 5

echo "Apache monitor, please wait while set the permission"
sleep 5
chmod 755 /root/cron/http.sh
echo "00 * * * * sh /root/cron/http.sh" >> /var/spool/cron/root
echo "Done..."
sleep 5

echo "Change the Apache port"
sed "s/apache_port=/apache_port=0.0.0.0:80/g /var/cpanel/cpanel.config
sed "s/apache_ssl_port=/apache_ssl_port=0.0.0.0:443/g /var/cpanel/cpanel.config
echo "Done..."
sleep

echo "Stalling the utilites"
yum install epel-release -y
yum install htop -y
yum install atop -y
yum install iftop -y
yum install apachetop -y
yum install mytop -y
yum install nethogs
yum install nload -y
yum update --disablerepo=epel
echo "Done..."
cd /root/
wget https://raw.githubusercontent.com/fagner-fmlo/arquivos/master/.mytop
echo "Mytop is configured"
sleep 5

echo "Disabling Selinux"
sed s/SELINUX=enforcing/SELINUX=disabled/g /etc/selinux/config
echo "Done..."
sleep 5

echo "Add script for update configserver"
cd /root/
https://raw.githubusercontent.com/fagner-fmlo/sysadmin/master/updatecs.sh
chmod +x updatecs.sh
echo "00 22 * * 1,6 bash /root/configserverupdate.sh" >> /var/spool/cron/root
