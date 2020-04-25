#!/bin/bash
# Script to fix permissions of accounts
# Written by: Vanessa Vasile 5/13/10
# http://thecpaneladmin.com

if [ "$#" -lt "1" ];then
        echo "Must specify user"
        exit;
fi

USER=$@

for user in $USER
do

    HOMEDIR=$(egrep "^${user}:" /etc/passwd | cut -d: -f6)

    if [ ! -f /var/cpanel/users/$user ]; then
        echo "$user user file missing, likely an invalid user"

    elif [ "$HOMEDIR" == "" ];then
        echo "Couldn't determine home directory for $user"


    else

        echo "Setting ownership for user $user"

        chown -R $user:$user $HOMEDIR
        chmod 711 $HOMEDIR
        chown $user:nobody $HOMEDIR/public_html $HOMEDIR/.htpasswds
        chown $user:mail $HOMEDIR/etc $HOMEDIR/etc/*/shadow $HOMEDIR/etc/*/passwd

        echo "Setting permissions for user $USER"

        find $HOMEDIR -type f -exec chmod 644 {} \; -print
        find $HOMEDIR -type d -exec chmod 755 {} \; -print
        find $HOMEDIR -type d -name cgi-bin -exec chmod 755 {} \; -print
        find $HOMEDIR -type f \( -name "*.pl" -o -name "*.perl" \) -exec chmod 755 {} \; -print

        chmod 750 $HOMEDIR/public_html

        if [ -d "$HOMEDIR/.cagefs" ]; then
            chmod 775 $HOMEDIR/.cagefs
            chmod 700 $HOMEDIR/.cagefs/tmp
            chmod 700 $HOMEDIR/.cagefs/var
            chmod 777 $HOMEDIR/.cagefs/cache
            chmod 777 $HOMEDIR/.cagefs/run
        fi
    fi
done

