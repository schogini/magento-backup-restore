#!/bin/sh

dd=$(date +%s)

[ ! -d app/etc/local.xml ] && echo You should be in the Magento root folder && exit
[ ! -f backup.sh ] && echo Unable to locate backup.sh && exit

h=$(cat app/etc/local.xml|grep -m 1 "<host>"|sed 's/^.*\[//'|sed 's/\].*$//')
db=$(cat app/etc/local.xml|grep "<dbname>"|sed 's/^.*\[//'|sed 's/\].*$//')
u=$(cat app/etc/local.xml|grep -m 1 "<username>"|sed 's/^.*\[//'|sed 's/\].*$//')
p=$(cat app/etc/local.xml|grep -m 1 "<password>"|sed 's/^.*\[//'|sed 's/\]\]>.*$//')

mysqldump -h $h -u $u -p${p} $db > ../$db-${dd}.sql
tar cjf ../magento-${dd}.bz2 .



