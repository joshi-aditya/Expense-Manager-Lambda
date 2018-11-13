read -p 'Enter stack name: ' STACK_NAME
echo $STACK_NAME

file_name="csye6225-lambda-*.zip"
dynamodb_table=Credentials
function=HelloWorld
domain_name=$(aws route53 list-hosted-zones --query 'HostedZones[0].Name' --output text)
bucket_name="lambda."$domain_name"csye6225.com"

STACK_ID=$(\aws cloudformation create-stack --stack-name ${STACK_NAME} \
--template-body file://csye6225-lambda-aws-cf-cicd.json \
--parameters ParameterKey=BucketName,ParameterValue=${bucket_name} ParameterKey=FunctionName,ParameterValue=${function} ParameterKey=FileName,ParameterValue=${file_name} \
--capabilities CAPABILITY_IAM \
--capabilities CAPABILITY_NAMED_IAM \
| jq -r .StackId \
)

echo "Waiting on ${STACK_ID} create completion.."
aws cloudformation wait stack-create-complete --stack-name ${STACK_ID}
if [ $? -ne 0 ]; then
	echo "Stack ${STACK_NAME} creation failed!"
    exit 1
else
    echo "Stack ${STACK_NAME} created successfully!"
fi