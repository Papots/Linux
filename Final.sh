#!/bin/bash

echo "#############################################"
echo "#                                           #"
echo "#           Installing HTTPD                #"
echo "#                                           #"
echo "#############################################"
yum install -y httpd
echo "success"
echo "#############################################"
echo "#                                           #"
echo "#             Starting HTTPD                #"
echo "#                                           #"
echo "#############################################"
systemctl start httpd
echo "success"
echo "#############################################"
echo "#                                           #"
echo "#             Adding Firewall               #"
echo "#                                           #"
echo "#############################################"

firewall-cmd --add-port 80/tcp --permanent
firewall-cmd --add-port 443/tcp --permanent

firewall-cmd --reload

systemctl enable httpd.service
echo "success"
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
cat > info.php <<- EOF
<?php phpinfo(); ?>
EOF
echo "success"
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


mysql_secure_installation <<EOF

y
papots
papots
y
y
y
y
EOF
echo "success"
echo "#############################################"
echo "#                                           #"
echo "#           Enabling mariadb                #"
echo "#                                           #"
echo "#############################################"

#Enable upon start up
systemctl enable mariadb
echo "success"
#use mysql tool
echo "#############################################"
echo "#                                           #"
echo "#       Verifying Installation              #"
echo "#                                           #"
echo "#############################################"
#variables
pass=papots
dname=wordpress
mysqladmin -u root -p$pass version 
echo "success"
echo "#############################################"
echo "#                                           #"
echo "#      Entering mysql admin account         #"
echo "#                                           #"
echo "#############################################"

echo "CREATE DATABASE wordpress; CREATE USER wordpressuser@localhost IDENTIFIED BY 'papots'; GRANT ALL PRIVILEGES ON wordpress.* TO wordpressuser@localhost IDENTIFIED BY 'papots'; FLUSH PRIVILEGES; show databases;" | mysql -u root -p$pass 
echo "success"

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
echo "#############################################"
echo "#                                           #"
echo "#  Congratulations! LAMP Stack Insttalled   #"
echo "#                                           #"
echo "#############################################"
