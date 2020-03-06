#!/bin/bash

rm -fv /tmp/horde_*
rm -fv /tmp/cache_*

find /home -name 'error_log' -exec rm {} \;

for user in `/bin/ls -A /var/cpanel/users` ; do rm -fv /home/$user/backup-*$user.tar.gz ; done

rm -fv /home/*/fantastico_backups

rm -fv /home/*/tmp/Cpanel_*

locate .pureftpd-upload | xargs rm -fv

rm -fv /home/a*/mail/new/*
rm -fv /home/b*/mail/new/*
rm -fv /home/c*/mail/new/*
rm -fv /home/d*/mail/new/*
rm -fv /home/e*/mail/new/*
rm -fv /home/f*/mail/new/*
rm -fv /home/g*/mail/new/*
rm -fv /home/h*/mail/new/*
rm -fv /home/i*/mail/new/*
rm -fv /home/j*/mail/new/*
rm -fv /home/l*/mail/new/*
rm -fv /home/m*/mail/new/*
rm -fv /home/n*/mail/new/*
rm -fv /home/o*/mail/new/*
rm -fv /home/p*/mail/new/*
rm -fv /home/q*/mail/new/*
rm -fv /home/r*/mail/new/*
rm -fv /home/s*/mail/new/*
rm -fv /home/t*/mail/new/*
rm -fv /home/u*/mail/new/*
rm -fv /home/v*/mail/new/*
rm -fv /home/x*/mail/new/*
rm -fv /home/z*/mail/new/*
rm -fv /home/y*/mail/new/*
rm -fv /home/w*/mail/new/*
rm -fv /home/k*/mail/new/*

rm -fv /home/*/mail/cur/*

rm -fv /home/*/mail/*/*/.Trash/cur/*
rm -fv /home/a*/mail/*/*/.Trash/cur/*
rm -fv /home/b*/mail/*/*/.Trash/cur/*
rm -fv /home/c*/mail/*/*/.Trash/cur/*
rm -fv /home/d*/mail/*/*/.Trash/cur/*
rm -fv /home/e*/mail/*/*/.Trash/cur/*
rm -fv /home/f*/mail/*/*/.Trash/cur/*
rm -fv /home/g*/mail/*/*/.Trash/cur/*
rm -fv /home/h*/mail/*/*/.Trash/cur/*
rm -fv /home/i*/mail/*/*/.Trash/cur/*
rm -fv /home/j*/mail/*/*/.Trash/cur/*
rm -fv /home/l*/mail/*/*/.Trash/cur/*
rm -fv /home/m*/mail/*/*/.Trash/cur/*
rm -fv /home/n*/mail/*/*/.Trash/cur/*
rm -fv /home/o*/mail/*/*/.Trash/cur/*
rm -fv /home/p*/mail/*/*/.Trash/cur/*
rm -fv /home/q*/mail/*/*/.Trash/cur/*
rm -fv /home/r*/mail/*/*/.Trash/cur/*
rm -fv /home/s*/mail/*/*/.Trash/cur/*
rm -fv /home/t*/mail/*/*/.Trash/cur/*
rm -fv /home/u*/mail/*/*/.Trash/cur/*
rm -fv /home/v*/mail/*/*/.Trash/cur/*
rm -fv /home/x*/mail/*/*/.Trash/cur/*
rm -fv /home/z*/mail/*/*/.Trash/cur/*
rm -fv /home/y*/mail/*/*/.Trash/cur/*
rm -fv /home/w*/mail/*/*/.Trash/cur/*
rm -fv /home/k*/mail/*/*/.Trash/cur/*
rm -fv /home/*/mail/*/*/.Trash/new/*

rm -fv /home/a*/mail/cur/*
rm -fv /home/b*/mail/cur/*
rm -fv /home/c*/mail/cur/*
rm -fv /home/d*/mail/cur/*
rm -fv /home/e*/mail/cur/*
rm -fv /home/f*/mail/cur/*
rm -fv /home/g*/mail/cur/*
rm -fv /home/h*/mail/cur/*
rm -fv /home/i*/mail/cur/*
rm -fv /home/j*/mail/cur/*
rm -fv /home/l*/mail/cur/*
rm -fv /home/m*/mail/cur/*
rm -fv /home/n*/mail/cur/*
rm -fv /home/o*/mail/cur/*
rm -fv /home/p*/mail/cur/*
rm -fv /home/q*/mail/cur/*
rm -fv /home/r*/mail/cur/*
rm -fv /home/s*/mail/cur/*
rm -fv /home/t*/mail/cur/*
rm -fv /home/u*/mail/cur/*
rm -fv /home/v*/mail/cur/*
rm -fv /home/x*/mail/cur/*
rm -fv /home/z*/mail/cur/*
rm -fv /home/y*/mail/cur/*
rm -fv /home/w*/mail/cur/*
rm -fv /home/k*/mail/cur/*

