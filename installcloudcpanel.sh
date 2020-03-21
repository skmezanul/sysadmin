#!/bin/bash

###############################################################################
# Copyright 2020							                                                
# Author: Fagner Mendes							                                          
# License: GNU Public License						                                      
# Version: 1.0								                                                  
# Email: fagner.mendes22@gmail.com					                                  
###############################################################################

echo "Starting the update server"
yum update -y > /root/yumupdate.log
echo "Done..."
clear

sleep 2

/scripts/upcp --force > /root/upcp.log
echo "Done"
clear

sleep 2

echo "Prepare to download the cpanel.config
mv /var/cpanel/cpanel.config /var/cpanel/cpanel.config-BKP
cd /var/cpanel/
wget https://raw.githubusercontent.com/fagner-fmlo/arquivos/master/cpanel.config
chmod 644 cpanel.config
echo "Done..."
clear

sleep 2

echo "Prepare to install PostgreSLQ"
/scripts/installpostgres > /root/postgresinstall.txt
echo "Done"
clear

sleep 2

echo "Setting default mail catching"
sed -i s/defaultmailaction=fail/defaultmailaction=fail/g' /var/cpanel/cpanel.config
echo "Done"

sleep 2

echo "Disable functions on Apache"
sed -i 's/TraceEnable ON/TraceEnable Off/g' /etc/apache2/conf/httpd.conf
sed -i 's/ServerTokens ProductOnly/ServerTokens ProductOnly/g' /etc/apache2/conf/httpd.conf
sed -i 's/FileETag None/FileETag None/g' /etc/apache2/conf/httpd.conf
apachectl graceful
echo "Done"

sleep 2

echo "Disable functions to Pure-FTPD"
sed -i 's/NoAnonymous no/NoAnonymous yes/g' /etc/pure-ftpd.conf
sed -i 's/PassivePortRange 49152 65534/PassivePortRange 30000 50000/g' /etc/pure-ftpd.conf
sed -i 's/AnonymousCantUpload no/AnonymousCantUpload yes/g' /etc/pure-ftpd.conf
/scripts/restartsrv_ftpd --restart
echo "Done..."
sleep 2

echo "Disabling GCC - Compilers"
chmod 750 /usr/bin/gcc

sleep 2

echo "Setting the another port to exim"
sed -i 's/daemon_smtp_ports = 25 : 465/daemon_smtp_ports = 25 : 465 : 587/g' /etc/exim.conf
/scripts/buildeximconf
echo "Done..."
clear

eleep 2

echo "Prepare to disable function on server"
/sbin/service cups stop
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
clear

sleep 2

echo "Prepare to install Modsec"
cd ~
wget https://download.configserver.com/cmc.tgz
tar -xzf cmc.tgz

cd cmc/
sh install.sh > modsecinstall.txt
echo "Done..."
clear

sleep 2

echo "Prepare to configure firewall CSF"
echo "Adding the user csf..."
useradd csf -s /bin/false
cd /etc/csf/messenger
echo "Renaming the index files"
mv index.html index.html-bkp
mv index.text index.text-bkp
echo "Done..."

echo "Downlowing the new files, please wait..."
sleep 2"
wget http://arquivos.servhost.com.br/index.html --http-user=romero --http-passwd=servhost84@!
wget http://arquivos.servhost.com.br/index.text --http-user=romero --http-passwd=servhost84@!
echo "Done..."

echo "Prepare to rename the files CSF"
cd /etc/csf
mv csf.allow csf.allow-bkp
mv csf.deny csf.deny-bkp
echo "Done..."

sleep 2

echo "Downlowing the new files, please wait..."
wget http://arquivos.servhost.com.br/csf.allow --http-user=romero --http-passwd=servhost84@!
wget http://arquivos.servhost.com.br/csf.deny --http-user=romero --http-passwd=servhost84@!
echo "Done..."

sleep 2

echo "Setting permissions for csf files configuration"
chmod 600 /etc/csf/csf.allow
chmod 600 /etc/csf/csf.deny
echo "Done..."

sleep 2

echo "Prepare to rename the files permission - TCP Wrapper"
cd /etc
mv hosts.allow hosts.allow-bkp 
mv hosts.deny hosts.deny-bkp
echo "Done..."

echo "Downlowding the new files, please wait..."
wget http://arquivos.servhost.com.br/hosts.allow --http-user=romero --http-passwd=servhost84@!
wget http://arquivos.servhost.com.br/hosts.deny --http-user=romero --http-passwd=servhost84@!
echo "Done..."
sleep 2

echo "Setting new permissions"
chmod 644 /etc/hosts.allow
chmod 644 /etc/hosts.deny
echo "Done..."

echo "user:mailman" >> /etc/csf/csf.pignore
echo "user:dovecot" >> /etc/csf/csf.pignore
echo "user:cpanelroundcube" >> /etc/csf/csf.pignore
echo "user:dovenull" >> /etc/csf/csf.pignore
echo "user:mysql" >> /etc/csf/csf.pignore
echo "user:mailnull" >> /etc/csf/csf.pignore
echo "user:rpm" >> /etc/csf/csf.pignore

echo "Prepare to rename csf.conf"
mv /etc/csf/csf.conf /etc/csf/csf.conf-BKP
cd /etc/csf/
wget https://raw.githubusercontent.com/fagner-fmlo/arquivos/master/csf.conf
chmod 600 csf.conf
csf -e
echo "Done..."
clear

sleep 2

echo "Prepare to install Mail Queue"
cd ~
wget https://download.configserver.com/cmq.tgz 
tar -xzf cmq.tgz 
cd cmq/ 
sh install.sh > /root/mailqueueinstall.txt
cd /root
rm -rf cmq.tgz
rm -r cmq/
echo "Done..."
clear

sleep 2

echo "Prepare to changes the options in the SSHD"
sed -i 's/Port 22/Port 1865/g' /etc/ssh/sshd_config
echo "Protocol 2" >> /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin yes/PermitRootLogin without-password/g' /etc/ssh/sshd_config
sed -i 's/#UseDNS yes/UseDNS no/g' /etc/ssh/sshd_config
/scripts/restartsrv_sshd --restart
echo "Done..."

sleep 2

echo "Prepare to changes the permission files"
chmod 750 /usr/bin/rcp
chmod 750 /usr/bin/wget
chmod 750 /usr/bin/lynx
chmod 750 /usr/bin/links
chmod 750 /usr/bin/scp
chmod 000 /etc/httpd/proxy/
chmod 000 /var/spool/samba/
chmod 000 /var/mail/vbox/
echo "Done..."
clear

sleep 2

echo "Prepare to intall DNS Check"
cd ~
wget http://download.ndchost.com/accountdnscheck/latest-accountdnscheck
sh latest-accountdnscheck > /root/dnscheckinstall.txt
rm -f latest-accountdnscheck
echo "Done..."
clear

sleep 2

echo "Prepare to edit recursion DNS"
sed -i 's/recursion yes/recursion no/g' /etc/named.conf
/scripts/restartsrv_named --restart
echo "Done..."

sleep 2

echo "Adding th script remotion"
echo "30 23 * * * sh /root/remover.sh" >> /var/spool/cron/root
wget http://arquivos.servhost.com.br/remover.sh --http-user=romero --http-passwd=servhost84@!
chmod 755 /root/remover.sh
echo "Done...

sleep 2

echo "Prepare to install EA customization, with all php version and all extensions"
cd /etc/cpanel/ea4/profiles/custom
wget https://raw.githubusercontent.com/fagner-fmlo/arquivos/master/ea-custom.json
echo "Install now, please wait...!"
sleep 2
/usr/local/bin/ea_install_profile --install /etc/cpanel/ea4/profiles/custom/ea-custom.json > /root/easyapacheinstall.txt
echo "Done..."

sleep 2

echo "Prepare to enable quotas"
/scripts/fixquotas
echo "Done..."

sleep 2


echo "Prepare to set script for check partitionon space"
mkdir /root/bkp/
cd /root/bkp
wget https://raw.githubusercontent.com/fagner-fmlo/sysadmin/master/spacemonitor.sh
mv spacemonitor.sh espaco.sh
chmod 755 /root/bkp/espaco.sh
echo "40 23 * * * sh /root/bkp/espaco.sh" >> /var/spool/cron/root
echo "Done..."

sleep 2

echo "Prepare to update MariaDB. Take Care, update MariDB first in WHM interface
echo "If the update was done, please Press <ENTER> to continue..."
read #pausa até que o ENTER seja pressionado
echo "Continuing"
mv /etc/my.cnf /etc/my.cnf-BKP
cd /etc/
wget https://raw.githubusercontent.com/fagner-fmlo/arquivos/master/my.cnf
chmod 644 /etc/my.cnf
/scripts/restartsrv-mysql --restart
echo "Done..."
clear

sleep 2

echo "Prepare to set Apache Monitor"
mkdir /root/cron/
cd /root/cron
wget https://raw.githubusercontent.com/fagner-fmlo/sysadmin/master/httpdmonitor.sh
mv httpdmonitor.sh http.sh
chmod 755 /root/cron/http.sh
echo "00 * * * * sh /root/cron/http.sh" >> /var/spool/cron/root
echo "Done..."
clear

sleep 2

echo "Check the hostname"
hostname
echo "Is correct, if so Press <ENTER> to continue..."
read #pausa até que o ENTER seja pressionado
echo "Done..."

sleep 2

echo "Prepare to fix erros for Roundcube"
rpm -e --nodeps cpanel-roundcubemail
/usr/local/cpanel/scripts/check_cpanel_rpms --fix > /root/fixroundcube.txt
echo "Done..."
clear

sleep 2

echo "Prepare to copy SSH key"
cd ~ ; mkdir .ssh ; chmod 700 .ssh ; cd .ssh
/root/.ssh/
scp -P 1865 root@IP:/root/.ssh/authorized_keys /root/.ssh/
chmod 600 authorized_keys
echo "Done..."

sleep 2




















