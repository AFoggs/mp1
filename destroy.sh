#!/bin/bash

VAR=`aws ec2 describe-instances --query 'Reservations[*].Instances[*].InstanceId'`

aws ec2 terminate-instances --instance-ids $VAR
echo 'instances deleted'

aws elb delete-load-balancer --load-balancer-name mp1-itmo-544x

echo 'load balancer deleted'

VOLUMES=$(aws ec2 describe-volumes --filters "Name=status,Values=available" --query "Volumes[*].{ID:VolumeID}")
aws ec2 delete-volume --volume-ids $VOLUMES
echo 'Volumes deleted'

aws s3 rm s3://itmo544-bucket-af --recursive
echo 'S3 Bucket Emptied'

aws s3api delete-bucket  --bucket itmo544-bucket-af
echo 'S3 Bucket Deleted'
