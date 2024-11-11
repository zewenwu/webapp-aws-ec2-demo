#!/bin/bash

### Set Environment Variables
AWS_REGION=us-east-1

### Install CodeDeploy Agent
yum update -y
yum install -y ruby
cd /home/ec2-user
wget https://aws-codedeploy-${AWS_REGION}.s3.amazonaws.com/latest/install
chmod +x ./install
./install auto
systemctl start codedeploy-agent
systemctl status codedeploy-agent

### Install Apache
yum update -y
yum install -y httpd.x86_64
systemctl start httpd.service
systemctl enable httpd.service
echo “Hello from instance: $(hostname -f)” > /var/www/html/index.html
