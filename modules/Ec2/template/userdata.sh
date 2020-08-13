#!/bin/bash
sudo yum update -y
sudo yum install -y httpd24 php56 php56-mysqlnd
sudo service httpd start
sudo chkconfig httpd on
sudo groupadd www
sudo usermod -a -G www ec2-user
sudo chgrp -R www /var/www
sudo chmod 2775 /var/www
find /var/www -type d -exec sudo chmod 2775 {} +
find /var/www -type f -exec sudo chmod 0664 {} +
cd /var/www
mkdir inc
cd inc
sudo echo "<?php
define('DB_SERVER', '${rds_endpoint}');
define('DB_USERNAME', '${username}');
define('DB_PASSWORD', '${password}');
define('DB_DATABASE', '${name}');
?>" > dbinfo.inc
sudo aws s3 cp s3://wahaj-webserver/SamplePage.php /var/www/html/SamplePage.php