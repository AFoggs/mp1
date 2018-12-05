#!/bin/bash

sudo apt-get update
sudo apt-get install -y apache2 git

sleep 10
cd /home/ubuntu
git clone https://github.com/AFoggs/About-me.git
git clone git@github.com:illinoistech-itm/afoggs.git 1>> /home/ubuntu/out.log 2>> /home/ubuntu/err.log
# git clone git@github.com:illinoistech-itm/afoggs.git 1>> /home/ubuntu/out2.log 2>> /home/ubuntu/err2.log
# sleep 10
# cd afoggs/
# git pull
sleep 10
# cd ..
sudo cp afoggs/index.html /var/www/html
#Moves file to proper place and gets most recent git due to unknown clone error of previous version.


# aws ec2 create-volume --size 10 --availability-zone us-east-2b
# VOLUMES=$(aws ec2 describe-volumes --filters "Name=status,Values=available" --query "Volumes[*].{ID:VolumeID}")
#
# aws ec2 wait volume-available --volume-ids $VOLUMES
#
# echo "Volume available"
#
# aws ec2 attach-volume --volume-id ${VOLUMES:0} --instance-id ${INSTANCES:0} --device /dev/xvdh
# echo 'volumes attached'



sudo mkdir -p /mnt/new-storage
sudo mount -t ext4 /dev/xvdh /mnt/new-storage
touch exist
mv exist /mnt/new-storage
echo /mnt/new-storage
#Ensures new storage works

#If doesn't work, create ami with most recent repo
