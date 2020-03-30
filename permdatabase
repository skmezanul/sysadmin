#!/bin/sh

echo ""
echo "This script will add the user's full permission to the database."

echo "Database:"
read database;
echo "User:"
read user;
echo "Pass:"
read pass;

mysql -u root -e "GRANT ALL ON $database.* TO $user@'localhost' IDENTIFIED BY '$pass';"
echo "#Done# Test with the password entered!"
echo "mysql -u $user -p"
