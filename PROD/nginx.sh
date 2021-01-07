#!/bin/bash
ips=( "$@" )

for ip in "${ips[@]}"
do

ssh -i /tmp/aws-key.pem -o 'StrictHostKeyChecking no' ubuntu@"$ip" << "ENDSSH"
until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
  sleep 5
done
sudo http_proxy=http://10.0.10.10:8888 apt update
sudo http_proxy=http://10.0.10.10:8888 apt install nginx -y
sudo rm -rf /var/www/html/*.*
ENDSSH
rsync --recursive -avz -e "ssh -i /tmp/aws-key.pem" --rsync-path='sudo rsync' /tmp/index/ ubuntu@"$ip":/var/www/html/

ssh -i /tmp/aws-key.pem -o  'StrictHostKeyChecking no' ubuntu@"$ip" 'sudo service nginx restart'
echo "***************************************************************************************************************"

done