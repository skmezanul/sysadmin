#!/bin/bash
SERVERNAME=$HOSTNAME
SCRIPT_NAME="$SERVERNAME - Batch IMAP TO IMAP"
MAIL=/bin/mail;
MAIL_RECIPIENT="deadmail AT mrbuckykat.com"
LOCK_FILE="/tmp/$SERVERNAME.imapsync.lockfile"
LOGFILE="imapsync_log.txt"

HOST1=imap.gmail.com
HOST2=191.252.134.207
DOMAIN=minhaempresa.com.br

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

imapsync --host1 $HOST1 --ssl1 --user1 "$USER_NAME" --password1 "$p1" --host2 $HOST2 --ssl2 --user2 "$USER_NAME" --password2 "$p1" \
 --noauthmd5 --maxbytespersecond 10000 --automap --exclude "\[Gmail\]$"

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
