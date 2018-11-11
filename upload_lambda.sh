#!/bin/bash
pwd
ls -al
aws lambda update-function-code \
--zip-file=fileb://*.zip \
--region=us-east-1 \
--function-name=HelloWorld
