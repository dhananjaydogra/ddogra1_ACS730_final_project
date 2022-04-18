#!/bin/bash
sudo yum -y update
sudo yum -y install httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h1>Welcome to ACS730 ${prefix}! My private IP is $myip in ${env} environment </h1><br>Built by Terraform! </br>"  >  /var/www/html/index.html
echo " <td><img src='https://ddogra1-acs730-project-dev.s3.amazonaws.com/dev-images/development-environment.png'/> </td>" >>  /var/www/html/index.html



sudo systemctl start httpd
sudo systemctl enable httpd