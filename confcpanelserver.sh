#!/bin/bash

###############################################################################
# Copyright 2020							                                                
# Author: Fagner Mendes							                                          
# License: GNU Public License						                                      
# Version: 1.0								                                                  
# Email: fagner.mendes22@gmail.com					                                  
###############################################################################

echo "Starting the update server"
yum update -y
echo "Done..."

/scripts/upcp --force

sed "s/IPADDR=/IPADDR=66.147.225.40/g /etc/sysconfig/network-scripts/ifcfg-ens3

echo "Disable Functions"

/sbin/chkconfig cups off 
/sbin/service nfslock stop
/sbin/chkconfig nfslock off
/sbin/service rpcidmapd stop 
/sbin/chkconfig rpcidmapd off
/sbin/service bluetooth stop
/sbin/chkconfig bluetooth off
/sbin/service anacron stop
/sbin/chkconfig anacron off
/sbin/service hidd stop
/sbin/chkconfig hidd off
/sbin/service pcscd stop
/sbin/chkconfig pcscd off
/sbin/service avahi-daemon stop
/sbin/chkconfig avahi-daemon off
echo "Done..."

sleep 2

echo "Change the permissions for any files"
chmod 750 /usr/bin/rcp
chmod 750 /usr/bin/wget
chmod 750 /usr/bin/lynx
chmod 750 /usr/bin/links
chmod 750 /usr/bin/scp
chmod 000 /etc/httpd/proxy/
chmod 000 /var/spool/samba/
chmod 000 /var/mail/vbox/

sleep 2

echo "Install DNS Check"

cd ~
wget http://download.ndchost.com/accountdnscheck/latest-accountdnscheck
sh latest-accountdnscheck
echo "Done..."

sleep 2

echo "Adding script remove"
echo "30 23 * * * sh /root/remover.sh" >> /var/spool/cron/root
chmod 755 /root/remover.sh
echo "Done..."

sleep 2

echo "Runnig the fix quotas"
/scripts/fixquotas
echo "Done..."

sleep 2

echo "Apache monitor, please wait while set the permission"
sleep 2
chmod 755 /root/cron/http.sh
echo "00 * * * * sh /root/cron/http.sh" >> /var/spool/cron/root
echo "Done..."
sleep 2

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
echo "Done..."
cd /root/
wget https://raw.githubusercontent.com/fagner-fmlo/arquivos/master/.mytop
echo "Mytop is configured"
sleep 2

echo "Disabling Selinux"
sed s/SELINUX=enforcing/SELINUX=disabled/g /etc/selinux/config
echo "Done..."
sleep 2

echo "Add script for update configserver"
cd /root/
https://raw.githubusercontent.com/fagner-fmlo/sysadmin/master/updatecs.sh
chmod +x updatecs.sh
echo "00 22 * * 1,6 bash /root/configserverupdate.sh" >> /var/spool/cron/root
