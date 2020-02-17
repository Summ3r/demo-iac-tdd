#!/bin/bash
yum update -y
yum install httpd -y
cd /var/www/html
echo "Hello, HashiTalks" > index.html
service httpd start