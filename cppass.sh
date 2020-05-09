#!/bin/bash

cat /etc/trueuserdomains | grep -q "^.*:\s$1$"
[ $? -ne '0' ] && { echo "Usuario nao existe" ;  }
    if [ "$2" == "" ];then
        pass=`cat /dev/urandom| tr -dc 'a-zA-Z0-9' | head -c 12`;
        export ALLOW_PASSWORD_CHANGE=1
        /scripts/chpass "$1" "$pass";
        mysql mysql -e "UPDATE user SET Password=password('$pass') WHERE User='$1'" && retval=0 || retval=1
        mysql mysql -e "flush privileges"
        if [ $retval -eq '0' ] ; then
                echo -e "Password changed to $pass\n";
        else
                echo "erro"
        fi
          
    else
        export ALLOW_PASSWORD_CHANGE=1
        /scripts/chpass "$1" "$2";
        mysql mysql -e "UPDATE user SET Password=password('$2') WHERE User='$1'" && retval=0 || retval=1
        mysql mysql -e "flush privileges"
        if [ $retval -eq '0' ] ; then
                echo -e "Password changed to $2\n";
        else
                echo "erro"
        fi
    fi; 
    /scripts/ftpupdate;
