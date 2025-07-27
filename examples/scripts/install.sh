#!/bin/bash
set -xe

echo "Running install.sh script..."

# Ensure HTTPD is running 
sudo yum install -y httpd
sudo systemctl enable httpd
sudo systemctl restart httpd

# Ensure permissions are correct
sudo chmod -R 755 /var/www/html

echo "Deployment finished."