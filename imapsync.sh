#!/bin/bash

####################################################################################
# File name - imapsync-batch.sh                                                    #
# Description - Batch IMAP to IMAP sync                                            #
# Creation - DEC 06 2010 - BN                                                      #
# Modified - DEC 13 2010 - BN                                                      #
# Requires - imapsync-accounts.txt                                                 #
# Requires - Username/password to be the same on both sides                        #
#          - may change this if I ever need it to backup to different account.     #
####################################################################################

#Crie um arquivo chamado imapsync-accounts.txt e insira o username sem o @ um ponto e virgula e a senha
#user1;password1
#user2;password2
#...
#user9;password9
#user10;password10



SERVERNAME=$HOSTNAME
SCRIPT_NAME="$SERVERNAME - Batch IMAP TO IMAP"
MAIL=/bin/mail;
MAIL_RECIPIENT="deadmail AT mrbuckykat.com"
LOCK_FILE="/tmp/$SERVERNAME.imapsync.lockfile"
LOGFILE="imapsync_log.txt"


#host1 is Source
HOST1=mail.somedomain.com


#host2 is Dest
HOST2=mail2.somedomain.com


#domain is where email account is "every thing after the @"
DOMAIN=somedomain.com

####################################################
###### Do not modify past here
####################################################

if [ ! -e $LOCK_FILE ]; then
touch $LOCK_FILE
#Run core script

TIME_NOW=$(date +"%Y-%m-%d %T")
echo "" >> $LOGFILE
echo "------------------------------------" >> $LOGFILE
echo "IMAPSync started - $TIME_NOW" >> $LOGFILE
echo "" >> $logfile

{ while IFS=';' read u1 p1; do
USER_NAME=$u1"@"$DOMAIN
echo "Syncing User $USER_NAME"
TIME_NOW=$(date +"%Y-%m-%d %T")
echo "Start Syncing User $u1"
echo "Starting $u1 $TIME_NOW" >> $LOGFILE
imapsync --nosyncacls --syncinternaldates --host1 $HOST1 --user1 "$USER_NAME" --password1 "$p1" --host2 $HOST2 --user2 "$USER_NAME" --password2 "$p1" --noauthmd5
TIME_NOW=$(date +"%Y-%m-%d %T")
echo "User $USER_NAME done"
echo "Finished $USER_NAME $TIME_NOW" >> $LOGFILE
echo "" >> $LOGFILE
done ; } < imapsync-accounts.txt
TIME_NOW=$(date +"%Y-%m-%d %T")
echo "" >> $LOGFILE
echo "IMAPSync Finished - $TIME_NOW" >> $LOGFILE
echo "------------------------------------" >> $LOGFILE

#End core script
#uncomment if you want a email once script is finished - useful for big syncs
#echo " IMAPSync Finished" | $MAIL -s "[$SCRIPT_NAME] Finshed" $MAIL_RECIPIENT
rm -f $LOCK_FILE


else
TIME_NOW=$(date +"%Y-%m-%d %T")
echo "$SCRIPT_NAME at $TIME_NOW is still running" | $MAIL -s "[$SCRIPT_NAME] !!WARNING!! still running" $MAIL_RECIPIENT
echo "$SCRIPT_NAME at $TIME_NOW is still running"
fi
