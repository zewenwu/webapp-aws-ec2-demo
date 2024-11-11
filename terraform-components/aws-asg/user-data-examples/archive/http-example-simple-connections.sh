#!/bin/bash
yum update -y
yum install -y httpd.x86_64
yum install -y php php-mysqlnd php-xml php-xmlrpc php-soap php-gd
yum install -y unzip jq mysql
yum install -y awscli

systemctl start httpd.service
systemctl enable httpd.service

### Download and install AWS SDK for PHP
wget wget https://docs.aws.amazon.com/aws-sdk-php/v3/download/aws.zip
mkdir /var/www/html/aws-sdk-php
unzip aws.zip -d /var/www/html/aws-sdk-php

### Set default region
DEFAULT_REGION='us-east-1'
aws configure set default.region $DEFAULT_REGION

### Connect to S3 bucket
BUCKET_NAME='application-bucket-0bn0'
# Download a file
aws s3 cp s3://$BUCKET_NAME/src/.keep /var/www/html/src/.keep

if [ $? -eq 0 ]; then echo 'Download from S3 bucket successful.'
else echo "Download from S3 bucket failed."
fi
# Upload a file
aws s3 cp /var/www/html/src/.keep s3://$BUCKET_NAME/src/.keep

if [ $? -eq 0 ]; then echo "Upload to S3 bucket successful."
else echo "Upload to S3 bucket failed."
fi

### Connect to RDS instance
DB_INSTANCE_IDENTIFIER='testdatabase'
RDS_SECRET_ID='rds!db-dd779a05-d4fe-451e-bb56-8a9b1477151e'

# Get the DB credentials from Secrets Manager
DB_CREDENTIALS=$(aws secretsmanager get-secret-value --secret-id $RDS_SECRET_ID --query SecretString --output text)
DB_CREDENTIALS=$(echo $DB_CREDENTIALS | jq -r '.username + ":" + .password')

# Get the RDS endpoint and split the credentials into username and password
ENDPOINT=$(aws rds describe-db-instances --db-instance-identifier $DB_INSTANCE_IDENTIFIER --query 'DBInstances[*].Endpoint.Address' --output text)
USERNAME=$(echo $DB_CREDENTIALS | cut -d: -f1)
PASSWORD=$(echo $DB_CREDENTIALS | cut -d: -f2)

# Connect to the RDS instance (no space after -p needed)
mysql -h $ENDPOINT -u $USERNAME -p$PASSWORD -e 'exit'

if [ $? -eq 0 ]; then echo "Connection to RDS instance successful."
else echo "Connection to RDS instance failed."
fi

echo “Hello from instance: $(hostname -f)” > /var/www/html/index.html
