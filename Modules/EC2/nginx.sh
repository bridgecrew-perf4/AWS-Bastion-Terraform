#!/bin/bash

ssh -i /tmp/aws-key.pem -o 'StrictHostKeyChecking no' ubuntu@10.0.20.20 << "ENDSSH"
until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
  sleep 5
done
sudo http_proxy=http://10.0.10.10:8888 apt update
sudo http_proxy=http://10.0.10.10:8888 apt install nginx -y
sudo rm -rf /var/www/html/*.*
ENDSSH

rsync --recursive -avz -e "ssh -i /tmp/aws-key.pem" --rsync-path='sudo rsync' /tmp/index/ ubuntu@10.0.20.20:/var/www/html/

ssh -i /tmp/aws-key.pem -o  'StrictHostKeyChecking no' ubuntu@10.0.20.20 'sudo service nginx restart'
echo "***************************************************************************************************************"
