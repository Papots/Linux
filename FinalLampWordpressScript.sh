#!/bin/bash

#Part 1 - Automated Installation of Apache Web Server
echo "#############################################"
echo "#                                           #"
echo "#           Installing HTTPD                #"
echo "#                                           #"
echo "#############################################"
yum install -y httpd
echo "success"
clear
echo "#############################################"
echo "#                                           #"
echo "#             Starting HTTPD                #"
echo "#                                           #"
echo "#############################################"
systemctl start httpd
echo "success"
clear
echo "#############################################"
echo "#                                           #"
echo "#             Adding Firewall               #"
echo "#                                           #"
echo "#############################################"

firewall-cmd --add-port 80/tcp --permanent
firewall-cmd --add-port 443/tcp --permanent

firewall-cmd --reload

systemctl enable httpd.service
clear
status=$( systemctl status httpd | grep -ic "running" )
clear
if [ $status -eq 1 ]
 then
        echo "#############################################"
        echo "#                                           #"
        echo "#        HTTPD is Running Condition         #"
        echo "#                                           #"
        echo "#############################################"
 else
        echo "#############################################"
        echo "#                                           #"
        echo "#           HTTPD is Not Running            #"
        echo "#                                           #"
        echo "#############################################"
fi
sleep 4
clear 
echo "PART 1 Finished!"
sleep 3

clear
#Part 2 - Automated Installation of Apache PHP Modules
echo "#############################################"
echo "#                                           #"
echo "#          Installing php-mysql             #"
echo "#                                           #"
echo "#############################################"
yum install -y php php-mysql

systemctl restart httpd.service

yum info php-fpm
yum install -y php-fpm

cd /var/www/html
cat > info.php <<Content
<?php phpinfo(); ?>
Content

echo "success"
systemctl start php-fpm
status=$( systemctl status php-fpm | grep -ic "running" )
clear
if [ $status -eq 1 ]
 then
        echo "#############################################"
        echo "#                                           #"
        echo "#       PHP-FPM is in Running Condition     #"
        echo "#                                           #"
        echo "#############################################"
 else
        echo "#############################################"
        echo "#                                           #"
        echo "#          PHP-FPM is Not Running           #"
        echo "#                                           #"
        echo "#############################################"
fi
sleep 4
clear
echo "PART 2 Finished!"
sleep 3
clear

#Part 3 - Automated Installation of MySQL/MariaDB
echo "#############################################"
echo "#                                           #"
echo "#          Installing mariadb               #"
echo "#                                           #"
echo "#############################################"
yum install -y mariadb-server mariadb
echo "success"
echo "#############################################"
echo "#                                           #"
echo "#           Starting mariadb                #"
echo "#                                           #"
echo "#############################################"
systemctl start mariadb
mysql_secure_installation <<Install

y
papots
papots
y
y
y
y
Install

echo "success"
echo "#############################################"
echo "#                                           #"
echo "#           Enabling mariadb                #"
echo "#                                           #"
echo "#############################################"

systemctl enable mariadb
echo "success"

echo "#############################################"
echo "#                                           #"
echo "#       Verifying Installation              #"
echo "#                                           #"
echo "#############################################"
#variables
pass=papots

mysqladmin -u root -p${pass} version 
echo "success"
echo "#############################################"
echo "#                                           #"
echo "#      Entering mysql admin account         #"
echo "#                                           #"
echo "#############################################"

 
mysql -u root -p${pass} <<SQL_QUERY
CREATE DATABASE wordpress;
CREATE USER wordpressuser@localhost IDENTIFIED BY 'papots';
GRANT ALL PRIVILEGES ON wordpress.* TO wordpressuser@localhost IDENTIFIED BY 'papots';
FLUSH PRIVILEGES;
SHOW DATABASES;
SQL_QUERY

echo "success"
status=$( systemctl status mariadb | grep -ic "running" )
clear
if [ $status -eq 1 ]
 then
        echo "#############################################"
        echo "#                                           #"
        echo "#       MariaDb is in Running Condition     #"
        echo "#                                           #"
        echo "#############################################"
 else
        echo "#############################################"
        echo "#                                           #"
        echo "#          MariaDB is Not Running           #"
        echo "#                                           #"
        echo "#############################################"
fi
sleep 4
clear
echo "PART 3 Finished!"
sleep 3
clear

#Part 4 - Automated Installation of WordPress Content Management System
echo "#############################################"
echo "#                                           #"
echo "#          Installing Wordpress             #"
echo "#                                           #"
echo "#############################################"

yum install -y php-gd
echo "success"
echo "#############################################"
echo "#                                           #"
echo "#          Restarting Service               #"
echo "#                                           #"
echo "#############################################"

systemctl restart httpd.service
echo "success"
echo "#############################################"
echo "#                                           #"
echo "#          Installing Wget                  #"
echo "#                                           #"
echo "#############################################"

yum install -y wget
echo "success"
echo "#############################################"
echo "#                                           #"
echo "#            Installing Tar                 #"
echo "#                                           #"
echo "#############################################"

yum install -y tar
echo "success"
echo "#############################################"
echo "#                                           #"
echo "#         Installing Zip File               #"
echo "#                                           #"
echo "#############################################"

cd /opt/ 
wget http://wordpress.org/latest.tar.gz
echo "success"
echo "#############################################"
echo "#                                           #"
echo "#         Extracting Zip File               #"
echo "#                                           #"
echo "#############################################"

tar xzvf latest.tar.gz
echo "success"
echo "#############################################"
echo "#                                           #"
echo "#            Installing Rsync               #"
echo "#                                           #"
echo "#############################################"


yum install -y rsync
echo "success"
echo "#############################################"
echo "#                                           #"
echo "#        Transfer file to html              #"
echo "#                                           #"
echo "#############################################"
echo "success"
rsync -avP wordpress/ /var/www/html/
cd /var/www/html/

echo "#############################################"
echo "#                                           #"
echo "#   Creating Directory & Change Ownership   #"
echo "#                                           #"
echo "#############################################"
echo "success"
mkdir /var/www/html/wp-content/uploads
chown -R apache:apache /var/www/html/*

echo "#############################################"
echo "#                                           #"
echo "#          Configuring wp-config            #"
echo "#                                           #"
echo "#############################################"
echo "success"
sed -e 's/database_name_here/wordpress/g' -e 's/username_here/wordpressuser/g' -e 's/password_here/papots/g' wp-config-sample.php > wp-config.php
echo "success"
echo "#############################################"
echo "#                                           #"
echo "#           Upgrading Wordpress             #"
echo "#                                           #"
echo "#############################################"
yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum install -y yum-utils
yum-config-manager --enable remi-php56 
yum install -y php php-mcrypt php-cli php-gd php-curl php-mysql php-ldap php-zip php-fileinfo
systemctl restart httpd.service
clear
echo "PART 4 Finished!"
sleep 3

echo "###########################################################"
echo "#                                                         #"
echo "#           Checking All Services if Running              #"
echo "#                                                         #"
echo "###########################################################"
sleep 4
clear
status1=$( systemctl status httpd | grep -ic "running" )
status2=$( systemctl status php-fpm | grep -ic "running" )
status3=$( systemctl status mariadb | grep -ic "running" )
cd /var/www/html
status4=$( ls -l | grep -ic wp-config.php )
if [ $status1 -eq 1 ]
 then
    echo "#############################################"
    echo "#                                           #"
    echo "#        HTTPD is in Running Condition      #"
    echo "#                                           #"
    echo "#############################################"
    if [ $status2 -eq 1 ]
     then
        echo "#############################################"
        echo "#                                           #"
        echo "#       PHP-FPM is in Running Condition     #"
        echo "#                                           #"
        echo "#############################################"
        if [ $status3 -eq 1 ]
         then
            echo "#############################################"
            echo "#                                           #"
            echo "#       MariaDb is in Running Condition     #"
            echo "#                                           #"
            echo "#############################################"
            if [ $status4 -eq 1 ]
            then 
                echo "#############################################"
                echo "#                                           #"
                echo "#          wp-config.php is created         #"
                echo "#                                           #"
                echo "#############################################"
            else
                echo "#############################################"
                echo "#                                           #"
                echo "#        wp-config.php Not Created          #"
                echo "#                                           #"
                echo "#############################################"
            fi
         else
            echo "#############################################"
            echo "#                                           #"
            echo "#          MariaDB is Not Running           #"
            echo "#                                           #"
            echo "#############################################"
        fi
    else
        echo "#############################################"
        echo "#                                           #"
        echo "#          PHP-FPM is Not Running           #"
        echo "#                                           #"
        echo "#############################################"
    fi
 else
    echo "#############################################"
    echo "#                                           #"
    echo "#           HTTPD is Not Running            #"
    echo "#                                           #"
    echo "#############################################"
fi
sleep 10
clear
echo "###########################################################"
echo "#                                                         #"
echo "#  Congratulations! LAMP Stack and Wordpress Insttalled   #"
echo "#                                                         #"
echo "###########################################################"
