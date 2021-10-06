#!/bin/bash

echo "#############################################"
echo "#                                           #"
echo "#           Installing HTTPD                #"
echo "#                                           #"
echo "#############################################"
yum install -y httpd

echo "#############################################"
echo "#                                           #"
echo "#             Starting HTTPD                #"
echo "#                                           #"
echo "#############################################"
systemctl start httpd
echo "#############################################"
echo "#                                           #"
echo "#             Adding Firewall               #"
echo "#                                           #"
echo "#############################################"

firewall-cmd --add-port 80/tcp --permanent
firewall-cmd --add-port 443/tcp --permanent

firewall-cmd --reload

systemctl enable httpd.service

echo "#############################################"
echo "#                                           #"
echo "#           Installing mysql                #"
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

echo "#############################################"
echo "#                                           #"
echo "#          Installing mariadb               #"
echo "#                                           #"
echo "#############################################"
yum install -y mariadb-server mariadb

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