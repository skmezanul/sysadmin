These are my scripts used in my daily routine as Sysadmin on cPanel and Cloudlinux servers.

In addition to these the routine is also applied to services:

#Exim

#Dovecot

#CSF

#CXS

#HTTPD

#Firewalld

#Crond

#spamd

#ftpd

#named

#mysqld

Verification and monitoring of spam, RBL's, analysis and blocking of abuse and phishings.

crowleyspam.sh - Verify spam in the server and check if the main IP is listed in RBL
deletequeue.sh - Delete all the queue in the server
doveadm.sh - Create subfolders in the Maidirbox
forcequeueautossl.sh - Force the queue AutoSSL in WHM
httpdmonitor.sh - Monitor for HTTPD Server
inodesearch.sh - Search for inodes uses for cPanel users in the system
lvestatsrebuilddb.sh - Rebuild LVE corrupted DB
nodejsinstall.sh - Install Node.js in the CloudLinux OS
rebuildrpmdb.sh - Rebuild RPM corrupted DB
removetrash.sh - Remove trash of all accout in the cPanel server
rpd.sh - Resolse packages duplicates in the system
spacemonitor.sh - Verify space in the some partition
updatecs.sh - Update ConfigServer Plugins in the server
updatemagic.sh - Update the MagicSpam for cPanel server
wprestore.sh - Restore the WordPress CMS
