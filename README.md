These are my scripts used in my daily routine as Sysadmin on cPanel and Cloudlinux servers.

In addition to these the routine is also applied to services:

#Exim

#Dovecot

#Csf

#Cxs

#Httpd

#Firewalld

#Crond

#Spamd

#Ftpd

#Named

#Mysqld

blacklistcheck.sh - Verify if the IP address are listed on RBL's

changeeximinterface.sh - Change the interface for exim service, the interface is default for main IP

confcpanelvpsserver.sh - Configure a VPS cPanel Server

checkmx.sh - Chech mx for massive domains

checkrdns.sh - Check rDNS for a massive list IPs

crowleyspam.sh - Verify spam in the server and check if the main IP is listed in RBL

cppass.sh - Change pass for cpanel account

createdir.sh - Create direcorys for a custom implemetation hooks in cPanel

createhooksspf.sh - Create a custom hooks - This hooks create a custom module SPF

cxsscan.sh - scan account with CXS

dkim.sh - Install DKIM in /etc/localdomains

deletequeue.sh - Delete all the queue in the server

doveadm.sh - Create subfolders in the Maidirbox

enablesa.sh - Enable SA for all accounts

engintroninstall.sh - Install Nginx

fixcpperm.sh - Fix permissions for cpanel account

fixcpperm.sh - Fix permissions for cpanel account

forcequeueautossl.sh - Force the queue AutoSSL in WHM
 
grantdatase.sh - Add a user to a database

httpdmonitor.sh - Monitor for HTTPD Server

imapsync-batch.sh - Migrate email via IMAP to IMAP

imapsyncgmail.sh - Migrate email from Gmail via IMAP

imapsyncgmailpowershell.bat - Migrate email from Gmail via IMAP (Script PowerShell)

imuniallowip.sh - Allow IP in Imunify360

imunifyAV.sh - Install ImunifyAV for cPanel

inodesearch.sh - Search for inodes uses for cPanel users in the system

instaliunify360 - Install Imunify360

installPAFP.sh - Install and configure a Server with PhP, Apache, Ftp and PostgreSql

installcloudcpanel.sh - Install and configure a cPanel cloud server by zero

installimunify360oncheap.sh - Install Imunify with cheap license

installtools.sh - Install services epel-release htop atop iftop apachetop mytop nload nethogs

joomlainstall.sh - Install Joomla CMS

listpop.sh - List mail account for of a domain

lpcp.sh - List the email account and change the password for a default pass

lvestatsrebuilddb.sh - Rebuild LVE corrupted DB

monitorfull.sh - A full monitoring for server

mysqlproc.sh - Verify mysql process - The same that Show Mysql Process on the WHM

nodejsinstall.sh - Install Node.js in the CloudLinux OS

permcpanel.sh - Fix perm for a cpanel account

pgsqlbackup.sh - Create backup for postgresql

premigration.sh - Used to the external manual migration

rebuildrpmdb.sh - Rebuild RPM corrupted DB

recoveryroundcube.sh - Repair the roundcube rpm and fix errors

removesendeinqueue.sh - Delete all mail of a specific acconunt frozen in queue

removetrash.sh - Remove trash of all accout in the cPanel server

roudcubebase.sh - Verify if the roudcube DB is mysql or sqllite

rpd.sh - Resolse packages duplicates in the system

softaculousinstall.sh - Install the Softaculous in cPanel server

sa-learn2.sh - Search SA for all accounts in cPanel server

sendermail.sh - Sender mail via CLI

spacemonitor.sh - Verify space in the some partition

suspend_cpuser.sh - Suspend an cpannel account

unspendreseller.sh - Unsuspend a specifical reseller and all accounts for that reseller

unsuspend_cpuser.sh - Unsuspend a specifical cpanel account

updatecs.sh - Update ConfigServer Plugins in the server

updatemagic.sh - Update the MagicSpam for cPanel server

wprestore.sh - Restore the WordPress CMS

monitorfull.sh - Monitoring of load, memory and process

sa-learn.sh - Train the SpaAssassin for new SPAM_TRAIN and HAM_TRAIN

permcpanel.sh - Find and correct permissions in cPanel
