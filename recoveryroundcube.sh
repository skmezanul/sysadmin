!#/bin/bash
rpm -e --nodeps cpanel-roundcubemail
/usr/local/cpanel/scripts/check_cpanel_rpms --fix
