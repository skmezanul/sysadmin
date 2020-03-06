#!/bin/sh
STARTAPACHE="/etc/init.d/httpd start"
############### Check httpd ################
SERVICE='httpd'
if ps ax | grep -v grep | grep $SERVICE > /dev/null
then
    echo "$SERVICE service running, everything is OK"
else
    echo "$SERVICE is not running, restarting $SERVICE"
        checkapache=`ps ax | grep -v grep | grep -c httpd`
                if [ $checkapache -le 0 ]
                then
                    	$STARTAPACHE
                                if ps ax | grep -v grep | grep $SERVICE > /dev/null
                then
                            echo "$SERVICE service is now restarted, everything is OK"
                                fi
                fi
fi



