#!/bin/bash
#INSTANCE() {

#  COUNT=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=$1" | jq ".Reservations[].Instances[].PrivateIpAddress" | grep -v null | wc -l)
#
#  if [ $COUNT -eq 0 ]; then
#
#  aws ec2 run-instances --image-id ami-0d997c5f64a74852c --instance-type t2.micro --security-group-ids sg-0ac1d1ef4519d3ce6 --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$1}]" | jq
#
#  else
#    echo "Instance already exists"
#
#    fi
#
#  sleep 5
#
#  IP=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=$1" | jq ".Reservations[].Instances[].PrivateIpAddress" | grep -v null | xargs)
#
#  sed -e "s/DNSNAME/$1-dev.roboshop.internal/" -e "s/IPADDRESS/${IP}/" record.json >/tmp/record.json
#  aws route53 change-resource-record-sets --hosted-zone-id Z037744027VYZPYJX9NVX --change-batch file:///tmp/record.json
#
#}



CREATE() {
  COUNT=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=$1" | jq ".Reservations[].Instances[].PrivateIpAddress" | grep -v null | wc -l)

if [ $COUNT -eq 0 ]; then

aws ec2 run-instances --launch-template LaunchTemplateId=lt-0c2f23ab38ce47240,Version=02 --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$1}]" "ResourceType=spot-instances-request,Tags=[{Key=Name,Value=$1}]" | jq &>/dev/null

else
  echo -e "\e[1;33m$1 Instance already exists\e[0m"
#return
#return will gonto out of loop
  fi

sleep 5

IP=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=$1" | jq ".Reservations[].Instances[].PrivateIpAddress" | grep -v null | xargs)

sed -e "s/DNSNAME/$1-dev.roboshop.internal/" -e "s/IPADDRESS/${IP}/" record.json >/tmp/record.json
aws route53 change-resource-record-sets --hosted-zone-id Z0917209HV543MHNGHQH --change-batch file:///tmp/record.json


}


if [ "$1" == "ALL" ]; then
ALL=(catalogue mongodb shipping cart payment user mysql rabbitmq frontend redis)
for component in ${ALL[*]}; do

echo -e "Creating instance - $component"
CREATE $component
done
else
  CREATE $1
fi

