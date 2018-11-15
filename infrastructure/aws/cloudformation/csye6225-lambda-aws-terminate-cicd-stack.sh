#!/bin/bash
read -p 'Enter stack name: ' STACK_NAME

domain_name=$(aws route53 list-hosted-zones --query 'HostedZones[0].Name' --output text)
bucket_name="lambda."$domain_name"csye6225.com"
echo "deleting contents of $bucket_name"

delete_s3_contents=$(aws s3 rm --recursive s3://$bucket_name --output text)

echo "Deleting stack.."
STACK_ID=$(\
    aws cloudformation delete-stack \
    --stack-name ${STACK_NAME} \
)

echo "Waiting on deletion.."
aws cloudformation wait stack-delete-complete --stack-name ${STACK_NAME}
if [ $? -ne 0 ]; then
	echo "Stack ${STACK_NAME} deletion failed!"
    exit 1
else
    echo "Stack ${STACK_NAME} deleted successfully!"
fi