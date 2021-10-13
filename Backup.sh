#!/bin/bash

echo "#############################################"
echo "#                                           #"
echo "#      Creating Directory for Backups       #"
echo "#                                           #"
echo "#############################################"
cd /opt/
mkdir backups
mysqldump -u root -p$password wordpress </opt/backups/wordpress_10-15-21.sql

echo "#############################################"
echo "#                                           #"
echo "#              Checking Backups             #"
echo "#                                           #"
echo "#############################################"
cd /opt/backups
var1=$( ls -l | grep -ic wordpress_10-15-21.sql )
if [ $var1 -eq 1 ]
 then 
    echo "#############################################"
    echo "#                                           #"
    echo "#              Backup Created!              #"
    echo "#                                           #"
    echo "#############################################"

    echo "Opening wordpress_10-15-21"
    cat /opt/backups/wordpress_10-15-21.sql

    echo "Compressing the backup"
    cd backups
	gzip wordpress_10-15-21.sql
	echo "Backup Compressed!"
	sleep 3
	clear
	echo "#############################################"
    echo "#                                           #"
    echo "#              BUCKUP DONE!                 #"
    echo "#                                           #"
    echo "#############################################"
 else
    echo "#############################################"
    echo "#                                           #"
    echo "#           Backup NOT Created!             #"
    echo "#                                           #"
    echo "#############################################"
fi
