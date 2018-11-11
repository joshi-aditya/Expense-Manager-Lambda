#!/bin/bash
pwd
ls -al
aws lambda update-function-code \
--zip-file=fileb://codedeploy_artifact/csye6225-lambda-*.zip \
--region=us-east-1 \
--function-name=HelloWorld