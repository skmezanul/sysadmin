#!/bin/bash

echo	-e	"###############################################################################"
echo	-e  "#                          Copyright 2020                                      "						    
echo	-e				                 			                                                
echo	-e  "#                        Author: Fagner Mendes                                 " 	
echo	-e  "#                      License: GNU Public License                             "					                                      
echo    -e  "#                          Version: 3.4                                        "			                                                  
echo	-e  "#                  Email: fagner.mendes22@gmail.com                            "				                                  
echo	-e	"###############################################################################"


<< 'CHANGELOG'
2.7 - 30 de março/2020 [Author: Fagner Mendes]
#Changes:
- Added the function to verify if cPanel is installed


2.9 - 31 de março/200 [Author: Fagner Mendes]
#Changes
- Changed the function tha check if cpanel is installed
- Changed the function to change permission in files
- Added the function that downlod php.ini for all php versions

3.0 - 03/04/20 [Author: Fagner Mendes]
#Changes
- Added the function that custom tamplate zone in cPanel
- Change the functions recursion in nemed.conf

3.1 - 14/04/20 [Author: Fagner Mendes]
#Changes
- Was added the step install ImunifyAV

3.2 - 16/04/20 [Author: Fagner Mendes]
#Changes
- Disabled the function that copy cpanel.config from another server

3.3 - 19/04/20 [Author: Fagner Mendes]
#Changes
- Removed step that download PHP.ini version 5.4 and 5.5
- Added the srep to download PHP.ini version 7.4

3.4 - 20/04/20 [Author: Fagner Mendes]
#Changes
- Added step Prepate to set SA custom for all accounts and resellers

CHANGELOG



echo ""


echo "Starting the update server"
yum update -y > /root/yumupdate.log
echo "Done..."
clear

sleep 5

echo "Checking if the cPanel is installed in this server"
if result=$(/usr/local/cpanel/cpanel -V 2>/dev/null); then
    stdout=$result
else
    rc=$?
    stderr=$result

if [ $? -eq 0 ]; then
  echo "cPanel is installed"
else
  echo "cPanel is not installed"
fi
  fi

clear
sleep 5

echo "Updating the cPanel, please wait..."
/scripts/upcp --force >> /root/upcp.log
echo "Done"
clear

sleep 5

echo "Prepare to download the cpanel.config
mv /var/cpanel/cpanel.config /var/cpanel/cpanel.config-BKP
cd /var/cpanel/
wget https://raw.githubusercontent.com/fagner-fmlo/arquivos/master/cpanel.config
chmod 644 cpanel.config
chown root.wheel /var/cpanel/cpanel.config
echo "Done..."
clear

sleep 5

echo "Prepare to install PostgreSLQ"
/scripts/installpostgres >> /root/postgresinstall.log
echo "Done"
clear

sleep 5

echo "Setting default mail catching"


sed -i s/defaultmailaction=fail/defaultmailaction=fail/g' /var/cpanel/cpanel.config
echo "Done"
clear

sleep 5

echo "Disable functions on Apache"
cp /etc/apache2/conf/httpd.conf /etc/apache2/conf/httpd.conf-BKP
sed -i 's/TraceEnable ON/TraceEnable Off/g' /etc/apache2/conf/httpd.conf
sed -i 's/ServerTokens ProductOnly/ServerTokens ProductOnly/g' /etc/apache2/conf/httpd.conf
sed -i 's/FileETag None/FileETag None/g' /etc/apache2/conf/httpd.conf
/scripts/rebuildhttpdconf
apachectl status
echo "Done"
clear

sleep 5

echo "Disable functions to Pure-FTPD"
sed -i 's/NoAnonymous no/NoAnonymous yes/g' /etc/pure-ftpd.conf
sed -i 's/PassivePortRange 30000 32000/PassivePortRange 30000 50000/g' /etc/pure-ftpd.conf
sed -i 's/AnonymousCantUpload no/AnonymousCantUpload yes/g' /etc/pure-ftpd.conf
/scripts/restartsrv_ftpd --restart
echo "Done..."
clear

sleep 5

echo "Setting the another port to exim"
sed -i 's/daemon_smtp_ports = 25 : 465/daemon_smtp_ports = 25 : 465 : 587/g' /etc/exim.conf
/scripts/buildeximconf
echo "Done..."
clear

eleep 5

echo "Prepare to disable functions in the server"
for SERVICE in autofs cups nfslock rpcidmapd rpcidmapd bluetooth anacron hidd pcscd avahi-daemon
do
        service "$SERVICE" stop > /dev/null 2>&1
        chkconfig "$SERVICE" off > /dev/null 2>&1
done
echo "Done..."
clear

sleep 5

echo "Prepare to install Modsec"
cd ~
wget https://download.configserver.com/cmc.tgz
tar -xzf cmc.tgz

cd cmc/
sh install.sh >> /root/modsecinstall.log
cd ~
rm -f cmc.tgz
rm -rf cmc/
echo "Done..."
clear

sleep 5

echo "Prepare to configure and install firewall CSF"
echo "Installing"
wget https://download.configserver.com/csf.tgz 
tar -xzf csf.tgz 
cd csf/ 
sh install.sh
rm -f /root/install.sh
clear

sleep 5

echo "Adding the user csf..."
useradd csf -s /bin/false
cd /etc/csf/messenger
echo "Renaming the index files"
mv index.html index.html-bkp
mv index.text index.text-bkp
echo "Done..."
clear

sleep 5


echo "Downlowing the new files, please wait..."
sleep 5"
wget http://arquivos.servhost.com.br/index.html --http-user=romero --http-passwd=servhost84@!
wget http://arquivos.servhost.com.br/index.text --http-user=romero --http-passwd=servhost84@!
echo "Done..."
clear

sleep 5

echo "Prepare to rename the files CSF"
cd /etc/csf
mv csf.allow csf.allow-bkp
mv csf.deny csf.deny-bkp
echo "Done..."
clear

sleep 5

echo "Downlowing the new files, please wait..."
wget http://arquivos.servhost.com.br/csf.allow --http-user=romero --http-passwd=servhost84@!
wget http://arquivos.servhost.com.br/csf.deny --http-user=romero --http-passwd=servhost84@!
echo "Done..."
clear

sleep 5

echo "Setting permissions for csf files configuration"
chmod 600 /etc/csf/csf.allow
chmod 600 /etc/csf/csf.deny
echo "Done..."
clear

sleep 5

echo "Prepare to rename the files permission - TCP Wrapper"
cd /etc
mv hosts.allow hosts.allow-bkp 
mv hosts.deny hosts.deny-bkp
echo "Done..."
clear

sleep 5

echo "Downlowding the new files, please wait..."
wget http://arquivos.servhost.com.br/hosts.allow --http-user=romero --http-passwd=servhost84@!
wget http://arquivos.servhost.com.br/hosts.deny --http-user=romero --http-passwd=servhost84@!
echo "Done..."
clear

sleep 5

echo "Setting new permissions"
chmod 644 /etc/hosts.allow
chmod 644 /etc/hosts.deny
echo "Done..."
clear

sleep 5

echo "user:mailman" >> /etc/csf/csf.pignore
echo "user:dovecot" >> /etc/csf/csf.pignore
echo "user:cpanelroundcube" >> /etc/csf/csf.pignore
echo "user:dovenull" >> /etc/csf/csf.pignore
echo "user:mysql" >> /etc/csf/csf.pignore
echo "user:mailnull" >> /etc/csf/csf.pignore
echo "user:rpm" >> /etc/csf/csf.pignore
clear

sleep 5

echo "Prepare to rename csf.conf"
mv /etc/csf/csf.conf /etc/csf/csf.conf-BKP
cd /etc/csf/
wget https://raw.githubusercontent.com/fagner-fmlo/arquivos/master/csf.conf
chmod 600 csf.conf
csf -r
echo "Done..."
clear

sleep 5

echo "Prepare to install Mail Queue"
cd ~
wget https://download.configserver.com/cmq.tgz 
tar -xzf cmq.tgz 
cd cmq/ 
sh install.sh >> /root/mailqueueinstall.log
cd /root
rm -rf cmq.tgz
rm -r cmq/
echo "Done..."
clear

sleep 5

echo "Prepare to changes the options in the SSHD"
sed -i 's/Port 1891/Port 1865/g' /etc/ssh/sshd_config
echo "Protocol 2" >> /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin yes/PermitRootLogin without-password/g' /etc/ssh/sshd_config
sed -i 's/#UseDNS yes/UseDNS no/g' /etc/ssh/sshd_config
sed -i '21d' /etc/ssh/sshd_config
/scripts/restartsrv_sshd --restart
echo "Done..."

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

sleep 5

echo "Prepare to intall DNS Check"
cd ~
wget http://download.ndchost.com/accountdnscheck/latest-accountdnscheck
sh latest-accountdnscheck >> /root/dnscheckinstall.log
rm -f latest-accountdnscheck
echo "Done..."
clear

sleep 5

echo "Prepare to edit recursion DNS"
sed -i '13s/recursion yes/ recursion no/g' /etc/named.conf
sed -i '55s/recursion yes/ recursion no/g' /etc/named.conf
sed -i '72s/recursion yes/ recursion no/g' /etc/named.conf
sed -i '113s/recursion yes/ recursion no/g' /etc/named.conf
/scripts/restartsrv_named --restart
echo "Done..."
clear

sleep 5

echo "Adding the script remotion"
echo "30 23 * * * sh /root/remover.sh" >> /var/spool/cron/root
wget http://arquivos.servhost.com.br/remover.sh --http-user=romero --http-passwd=servhost84@!
chmod 755 /root/remover.sh
echo "Done...
clear

sleep 5

echo "Prepare to install EA customization, since 5.4 to 7.3 and any extensions"
mkdir -p /etc/cpanel/ea4/profiles/custom
cd /etc/cpanel/ea4/profiles/custom
wget https://raw.githubusercontent.com/fagner-fmlo/arquivos/master/ea-custom.json
echo "Install now, please wait...!"
sleep 5
/usr/local/bin/ea_install_profile --install /etc/cpanel/ea4/profiles/custom/ea-custom.json >> /root/easyapacheinstall.log
echo "Done..."
clear

sleep 5


cd /opt/cpanel/ea-php56/root/etc/
mv php.ini php.ini-bkp
wget https://raw.githubusercontent.com/fagner-fmlo/arquivos/master/ea.5.6-php.ini
mv ea.5.6-php.ini php.ini
echo "done"


cd /opt/cpanel/ea-php70/root/etc/
mv php.ini php.ini-bkp
wget https://raw.githubusercontent.com/fagner-fmlo/arquivos/master/ea.7.0-php.ini
mv ea.7.0-php.ini php.ini
echo "done"


cd /opt/cpanel/ea-php71/root/etc/
mv php.ini php.ini-bkp
wget https://raw.githubusercontent.com/fagner-fmlo/arquivos/master/ea.7.1-php.ini
mv ea.7.1-php.ini php.ini
echo "done"


cd /opt/cpanel/ea-php72/root/etc/
mv php.ini php.ini-bkp
wget https://raw.githubusercontent.com/fagner-fmlo/arquivos/master/ea.7.2-php.ini
mv ea.7.2-php.ini php.ini
echo "done"


cd /opt/cpanel/ea-php73/root/etc/
mv php.ini php.ini-bkp
wget https://raw.githubusercontent.com/fagner-fmlo/arquivos/master/ea.7.3-php.ini
mv ea.7.3-php.ini php.ini
echo "done"

cd /opt/cpanel/ea-php74/root/etc/
mv php.ini php.ini-bkp
wget https://raw.githubusercontent.com/fagner-fmlo/arquivos/master/ea.7.4-php.ini
mv ea.7.4-php.ini php.ini
echo "done"


echo "Prepare to enable quotas"
/scripts/fixquotas
echo "Done..."
clear

sleep 5


echo "Prepare to set script for check partition space"
cd ~
mkdir -p /root/bkp/
cd /root/bkp
wget https://raw.githubusercontent.com/fagner-fmlo/sysadmin/master/spacemonitor.sh
mv spacemonitor.sh espaco.sh
chmod 755 /root/bkp/espaco.sh
echo "40 23 * * * sh /root/bkp/espaco.sh" >> /var/spool/cron/root
echo "Done..."


sleep 5

echo "Prepare to update MariaDB. Take Care, update MariaDB first in WHM interface
echo "If the update was done, please Press <ENTER> to continue..."
read #pause until ENTER is pressed
echo "Continuing"
mv /etc/my.cnf /etc/my.cnf-BKP
cd /etc/
wget https://raw.githubusercontent.com/fagner-fmlo/arquivos/master/my.cnf
chmod 644 /etc/my.cnf
/scripts/restartsrv-mysql --restart
echo "Done..."
clear

sleep 5

echo "Prepare to set Apache Monitor"
mkdir -p /root/cron/
cd /root/cron
wget https://raw.githubusercontent.com/fagner-fmlo/sysadmin/master/httpdmonitor.sh
mv httpdmonitor.sh http.sh
chmod 755 /root/cron/http.sh
echo "00 * * * * sh /root/cron/http.sh" >> /var/spool/cron/root
echo "Done..."
clear

sleep 5

echo "Check the hostname"
HOSTNAME=`echo $HOSTNAME`
echo "'$HOSTNAME'Is correct?, otherwise Press Press <ENTER> and enter the new hostname"
read #pause until ENTER is pressed
clear
echo "Inform the new hostname"
read new_hostname
echo $new_hostname > /etc/hostname
clear
echo "The new hostname is: '$new_hostname' "

sleep 5

echo "Prepare to fix erros for Roundcube"
rpm -e --nodeps cpanel-roundcubemail
/usr/local/cpanel/scripts/check_cpanel_rpms --fix >> /root/fixroundcube.log
echo "Done..."
clear

sleep 5

#echo "Prepare to copy SSH key"
#cd ~ ; mkdir .ssh ; chmod 700 .ssh ; cd .ssh
#mv /root/.ssh/authorized_keys /root/.ssh/authorized_keys-BKP
#/root/.ssh/
#scp -P 1865 root@IP:/root/.ssh/authorized_keys /root/.ssh/
#chmod 600 authorized_keys
#echo "Done..."
#clear

sleep 5


echo "Prepare to install monitoring tools"
yum install epel-release -y > /root/yum.log
yum install htop -y >> /root/yum.log
yum install atop -y >> /root/yum.log
yum install iftop -y >> /root/yum.log
yum install apachetop -y >> /root/yum.log
yum install mytop -y >> /root/yum.log
yum install nethogs -y >> /root/yum.log
yum install nload -y >> /root/yum.log
yum update --disablerepo=epel

cd /root/
wget https://raw.githubusercontent.com/fagner-fmlo/arquivos/master/.mytop
echo "Done..."
clear

sleep 5

echo "Prepare to disable Selinux"
sed -i 's/permissive\|enforcing/disabled/g' /etc/selinux/config
echo "Disabled"
clear

sleep 5

echo "Prepare to enable configserver update"
echo "00 22 * * 1,6 bash /root/configserverupdate.sh" >> /var/spool/cron/root
cd /root
wget https://raw.githubusercontent.com/fagner-fmlo/sysadmin/master/updatecs.sh
mv /root/updatecs.sh /root/configserverupdate.sh
echo "Done..."
clear

sleep 5

echo "Prepare to check Roundcube DB"
bash <( curl -s https://raw.githubusercontent.com/fagner-fmlo/sysadmin/master/roudcubebase.sh)
echo "It's all right? Press <ENTER> to continue"
read #pause until ENTER is pressed
echo "Done..."


sleep 5

echo "Prepare to change the logrotate"
mv /etc/logrotate.d/maillog /etc/logrotate.d/maillog-BKP
cd /etc/logrotate.d/
wget https://raw.githubusercontent.com/fagner-fmlo/arquivos/master/maillog
wget https://raw.githubusercontent.com/fagner-fmlo/arquivos/master/apache
wget https://raw.githubusercontent.com/fagner-fmlo/arquivos/master/cpanel
wget https://raw.githubusercontent.com/fagner-fmlo/arquivos/master/messages
wget https://raw.githubusercontent.com/fagner-fmlo/arquivos/master/ssh
echo "Done..."
clear


echo "Prepare to create hook SPF - custom template dns zones"
bash <( curl -s https://raw.githubusercontent.com/fagner-fmlo/sysadmin/master/createhooksspf.sh)
echo "Done"
clear
sleep 5


echo ""

echo "Prepare to install ImunifyAV in the server"
https://raw.githubusercontent.com/fagner-fmlo/sysadmin/master/imuifyAV.sh
echo "Imunify was installed with success"
clear


echo "Prepate to set SA custom for all accounts and resellers"
sleep 5
mkdir -p /root/cpanel3-skel/.spamassassin
mkdir -p /root/cpanel3-skel/cpanel3-skel/.spamassassin
cd mkdir -p /root/cpanel3-skel/.spamassassin
wget https://raw.githubusercontent.com/fagner-fmlo/arquivos/master/user_prefs
cd mkdir -p /root/cpanel3-skel/cpanel3-skel/.spamassassin
wget https://raw.githubusercontent.com/fagner-fmlo/arquivos/master/user_prefs
echo "Done, nothing to do!"


echo ""


echo "Prepare to send emails"
cat /root/yumupdate.log | mail -s "yumupdate.log" fagner.mendes22@gmail.com
cat /root/upcp.log | mail -s "upcp.log" fagner.mendes22@gmail.com
cat /root/postgresinstall.log | mail -s "postgresinstall.log" fagner.mendes22@gmail.com
cat /root/modsecinstall.log | mail -s "modsecinstall.log" fagner.mendes22@gmail.com
cat /root/mailqueueinstall.log | mail -s "mailqueueinstall.log" fagner.mendes22@gmail.com
cat /root/dnscheckinstall.log | mail -s "dnscheckinstall.log" fagner.mendes22@gmail.com
cat /root/easyapacheinstall.log | mail -s "easyapacheinstall.log" fagner.mendes22@gmail.com
cat /root/fixroundcube.log | mail -s "fixroundcube.log" fagner.mendes22@gmail.com
cat /root/yum.log | mail -s "yum.log" fagner.mendes22@gmail.com

clear
