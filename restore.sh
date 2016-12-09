#!/bin/sh
yn () {
    while true; do
        read -p "$1 [N]? " yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            [\ ]* ) return 1;;
            [Xx]* ) exit 1;;
            #* ) echo "Please answer yes or no or X to exit. [N]";;
            * ) return 1;;
        esac
    done
}
[ $# -eq 0 ] && echo Need dd number && exit

dd=$1

[ ! -d app/etc/local.xml ] && echo You should be in the Magento root folder && exit
[ ! -f backup.sh ] && echo Unable to locate backup.sh && exit

h=$(cat app/etc/local.xml|grep -m 1 "<host>"|sed 's/^.*\[//'|sed 's/\].*$//')
db=$(cat app/etc/local.xml|grep "<dbname>"|sed 's/^.*\[//'|sed 's/\].*$//')
u=$(cat app/etc/local.xml|grep -m 1 "<username>"|sed 's/^.*\[//'|sed 's/\].*$//')
p=$(cat app/etc/local.xml|grep -m 1 "<password>"|sed 's/^.*\[//'|sed 's/\]\]>.*$//')

if yn "Backup before overwriting"; then
  ./backup.sh
  echo Backup completed
fi

if yn "Are you sure you want to RESTORE/OVERWRITE Magento Installation!!!"; then
	     cat ../$db-${dd}.sql|mysql -h $h -u $u -p${p} $db 
        tar xjf ../magento-${dd}.bz2
fi
echo Clearing cache and session folders
rm -fr var/cache/* var/session/* 
