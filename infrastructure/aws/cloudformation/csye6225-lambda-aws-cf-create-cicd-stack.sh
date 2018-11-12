read -p 'Enter stack name: ' STACK_NAME
echo $STACK_NAME

account_id=$(aws sts get-caller-identity --query "Account" --output text)
region=us-east-1
application_name=csye6225-fall2018-lambda
dynamodb_table=Credentials
function=HelloWorld
resource1="arn:aws:dynamodb:$region:$account_id:table/$dynamodb_table"
resource2="arn:aws:logs:$region:$account_id:*"
resource3="arn:aws:logs:$region:$account_id:log-group:/aws/lambda/$function:*"

STACK_ID=$(\aws cloudformation create-stack --stack-name ${STACK_NAME} \
--template-body file://csye6225-lambda-aws-cf-cicd.json \
--parameters ParameterKey=Resource1,ParameterValue=$resource1 ParameterKey=Resource2,ParameterValue=$resource2 ParameterKey=Resource3,ParameterValue=$resource3 \
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