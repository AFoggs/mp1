aws ec2 run-instances --image-id ami-0fdde670aa5c23c1c --count 3 --instance-type t2.micro --key-name itmo544 --security-groups mp1-security --user-data file://create-app.sh

INSTANCES=$(aws ec2 describe-instances --filter "Name=instance-state-name,Values=running" --query 'Reservations[*].Instances[*].InstanceID')

echo $INSTANCES

echo 'instances created'
aws ec2 wait instance-running --filter "Name=instance-state-name,Values=running" --instance-ids $INSTANCES
echo 'instances running'
aws ec2 wait instance-status-ok --instance-ids $INSTANCES
echo 'instances okay'

echo 'Creating load balancer'
aws elbv2 create-load-balancer --name mp1-itmo-544x --type network --subnets subnet-cb0391b1
echo 'Creating target group'
aws elbv2 create-target-group --name mp1-machines --protocol TCP --port 80 --vpc-id vpc-830d31eb
echo 'Creating load balancer listner'
aws elbv2 create-listener --load-balancer-arn arn:aws:elasticloadbalancing:us-east-2:346269183575:loadbalancer/net/mp1-itmo-544x/7cc21de5bf3fb5fc --protocol TCP --port 80 --default-actions Type=forward,TargetGroupArn=arn:aws:elasticloadbalancing:us-east-2:346269183575:targetgroup/mp1-machines/ac4682f4d7a3d00e
echo 'Creating cookie stickiness'
aws elbv2 modify-target-group-attributes --target-group-arn arn:aws:elasticloadbalancing:us-east-2:346269183575:targetgroup/mp1-machines/ac4682f4d7a3d00e --attributes Key=deregistration_delay.timeout_seconds,Value=600

# aws elb create-load-balancer --load-balancer-name mp1-itmo-544x --listeners "Protocol=HTTP,LoadBalancerPort=80,InstanceProtocol=HTTP,InstancePort=80" --availability-zones us-east-2b
# echo 'Registering load balancer'
# aws elb register-instances-with-load-balancer --load-balancer-name mp1-itmo-544x --instances $INSTANCES
# echo 'Creating cookie stickiness'
# aws elb create-lb-cookie-stickiness-policy --load-balancer-name mp1-itmo-544x --policy-name mp1-cookie-policy --cookie-expiration-period 60

aws ec2 create-volume --size 10 --availability-zone us-east-2b
VOLUMES=$(aws ec2 describe-volumes --filters "Name=status,Values=available" --query "Volumes[*].{ID:VolumeID}")

aws ec2 wait volume-available --volume-ids $VOLUMES

echo "Volume available"

aws ec2 attach-volume --volume-id ${VOLUMES:0} --instance-id ${INSTANCES:0} --device /dev/xvdh
echo 'volumes attached'


aws s3api create-bucket --bucket itmo544-bucket-af --region us-east-1 --acl public-read
echo 'bucket created'

echo 'placing objects in bucket'
aws s3api put-object --bucket itmo544-bucket-af --key ../images/prophoto.jpeg --body my-face --acl public-read
aws s3api put-object --bucket itmo544-bucket-af --key ../images/illinoistech.png --body iit-mascot --acl public-read
echo 'objects placed in bucket'
