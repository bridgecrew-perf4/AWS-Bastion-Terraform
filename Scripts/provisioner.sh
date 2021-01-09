#!/bin/bash
ip=$1

until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
  sleep 5
done

echo "***************************************************************************************************************"
echo "Running update"
apt update

echo "***************************************************************************************************************"
echo "Install of tinyproxy"
apt install -y tinyproxy

echo "***************************************************************************************************************"
echo "Updating parameters in tinyproxy.conf"

sed -i 's 127.0.0.1 '$ip' g' /etc/tinyproxy/tinyproxy.conf

echo "***************************************************************************************************************"
echo "Restart of tinyproxy service"
service tinyproxy restart
echo "***************************************************************************************************************"