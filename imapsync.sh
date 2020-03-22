#!/bin/bash

# Source and destination mail server setting
SERVER1=post.literal.si
SERVER2=cp2.hosterdam.com

# Select appropriate auth mechanism.
#AUTHMECH1="--authmech1 LOGIN"
#AUTHMECH2="--authmech2 LOGIN"

# Uncomment if you want to start test/dryrun only. No emails will be transfered!
#TESTONLY="--dry"

# Path to imapsync
imapsync=/usr/bin/imapsync

# Users file
if [ -z "$1" ]
then
echo "No users text file given." 
exit
fi

if [ ! -f "$1" ]
then
echo "Given users text file \"$1\" does not exist" 
exit
fi

# start loop
{ while IFS=';' read  u1 p1 u2 p2; do
	$imapsync ${TESTONLY} ${AUTHMECH1} --host1 ${SERVER1} --user1 "$u1" --password1 "$p1" ${AUTHMECH2} --host2 ${SERVER2} --user2 "$u2" --password2 "$p2"
done ; } < $1
