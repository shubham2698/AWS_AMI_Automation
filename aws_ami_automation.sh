#!/bin/bash
read -p "Enter file name : " filename;
cat ${filename} | while read f1 f2 f3;
	f1=$(echo "${f1}");
	f2=$(echo "${f2}");
	f3=$(echo "${f3}");
do
for id in $(aws ec2 describe-instances --query Reservations[*].Instances[*].[InstanceId] --region "$f1" --profile "$f2" --output text);
do
id=$(echo "${id}")
Project_name=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$id" "Name=key,Values=Project" --query Tags[0].Value --profile "$f2" --region "$f1");
if [[ "$Project_name" =~ "${f3}" ]];
then
	instance_name=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$id" "Name=key,Values=Name" --query Tags[0].Value --output text --profile "$f2" --region "$f1");
	ami_id=$(aws ec2 create-image --instance-id "$id" --no-reboot --name "${instance_name}-back-testonly-v1" --description "Created For Backup from cli on `date`" --output text --profile sandbox-new --region "$f1");
	echo $id $instance_name $ami_id;
fi
done
done