#!/bin/bash
sudo yum -y update
sudo yum -y install httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
sudo aws s3 cp s3://ddogra1-acs730-project-dev/dev-images/development-environment.png  /var/www/html/image
echo "<h1>Welcome to ACS730 ${prefix}! My private IP is $myip in ${env} environment </h1><br>Built by Terraform! </br>"  >  /var/www/html/index.html
echo " <img src='image'/>" >>  /var/www/html/index.html
sudo systemctl start httpd
sudo systemctl enable httpd