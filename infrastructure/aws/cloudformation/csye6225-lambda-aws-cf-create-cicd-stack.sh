read -p 'Enter stack name: ' STACK_NAME
echo $STACK_NAME

TRAVIS_UPLOAD_TO_S3_POLICY_NAME=Travis-Upload-To-Lambda-S3
#TRAVIS_CODE_DEPLOY_POLICY_NAME=Travis-Code-Deploy
#CODE_DEPLOY_SERVICE_ROLE=CodeDeployServiceRole
#CODE_DEPLOY_SERVICEROLE_SERVICE=codedeploy.amazonaws.com
account_id=$(aws sts get-caller-identity --query "Account" --output text)
region=us-east-1
application_name=csye6225-fall2018-lambda
resourse1="arn:aws:iam::"$account_id":user/travis-ci"
#resourse2="arn:aws:codedeploy:"$region":"$account_id":application:"$application_name
#resourse3="arn:aws:codedeploy:"$region":"$account_id":deploymentconfig:CodeDeployDefault.OneAtATime"
#resourse4="arn:aws:codedeploy:"$region":"$account_id":deploymentconfig:CodeDeployDefault.HalfAtATime"
#resourse5="arn:aws:codedeploy:"$region":"$account_id":deploymentconfig:CodeDeployDefault.AllAtOnce"
domain_name=$(aws route53 list-hosted-zones --query 'HostedZones[0].Name' --output text)
bucket_name="lambda."$domain_name"csye6225.com"

STACK_ID=$(\aws cloudformation create-stack --stack-name ${STACK_NAME} \
--template-body file://csye6225-lambda-aws-cf-cicd.json \
--parameters ParameterKey=Resource1,ParameterValue=$resourse1 ParameterKey=TravisUploadToS3PolicyName,ParameterValue=$TRAVIS_UPLOAD_TO_S3_POLICY_NAME ParameterKey=ApplicationName,ParameterValue=${application_name} ParameterKey=BucketName,ParameterValue=${bucket_name} \
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
