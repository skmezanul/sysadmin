#!/bin/bash

cd /opt/cpanel/ea-php56/root/etc/
mv php.ini php.ini-bkp
wget https://raw.githubusercontent.com/fagner-fmlo/arquivos/master/ea.5.6-php.ini
mv ea.5.6-php.ini php.ini


cd /opt/cpanel/ea-php70/root/etc/
mv php.ini php.ini-bkp
wget https://raw.githubusercontent.com/fagner-fmlo/arquivos/master/ea.7.0-php.ini
mv ea.7.0-php.ini php.ini


cd /opt/cpanel/ea-php71/root/etc/
mv php.ini php.ini-bkp
wget https://raw.githubusercontent.com/fagner-fmlo/arquivos/master/ea.7.1-php.ini
mv ea.7.1-php.ini php.ini


cd /opt/cpanel/ea-php72/root/etc/
mv php.ini php.ini-bkp
wget https://raw.githubusercontent.com/fagner-fmlo/arquivos/master/ea.7.2-php.ini
mv ea.7.2-php.ini php.ini


cd /opt/cpanel/ea-php73/root/etc/
mv php.ini php.ini-bkp
wget https://raw.githubusercontent.com/fagner-fmlo/arquivos/master/ea.7.3-php.ini
mv ea.7.3-php.ini php.ini


cd /opt/cpanel/ea-php74/root/etc/
mv php.ini php.ini-bkp
wget https://raw.githubusercontent.com/fagner-fmlo/arquivos/master/ea.7.4-php.ini
mv ea.7.4-php.ini php.ini
