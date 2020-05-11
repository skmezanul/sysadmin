#!/bin/bash

echo "Prepare to install Let's Encrypt"
/usr/local/cpanel/scripts/install_lets_encrypt_autossl_provider
update_cpanelv2 --ssl-services

echo "Go to the WHM of the server in the "Auto SSL" tab, put Lets Encrypt and agree to the terms. If Done Press <Enter> to continue"
read
echo "Done"
