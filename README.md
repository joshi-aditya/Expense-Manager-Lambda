# csye6225-fall2018-lambda-repository

## Team-members

* Neha Bhangale : bhangale.n@husky.neu.edu 
* Aditya Joshi  : joshi.adit@husky.neu.edu
* Sneha Kawitkar  : kawitkar.s@husky.neu.edu
* Meven Dcunha  : dcunha.m@husky.neu.edu

## Email Service Using AWS Lambda Function
As a user,
> You will be able to request reset password link.

## Getting Started
Clone the repository on your local machine

### Prerequisites

Install json parser in fedora using following command
```
sudo dnf install jq
```
### Stack workflow
#### Stack creation
1. To create lambda cicd stack:
    - Run the following script in terminal
      ```
      bash csye6225-lambda-aws-cf-create-cicd-stack.sh
      ```
    - Enter the name of the stack to be created
2. Do a git push/restart build over [Travis ci](https://travis-ci.com)
3. To create lambda serverless stack which will create lambda function:
    - Run the following script in terminal
      ```
      bash csye6225-lambda-aws-cf-create-serverless-stack.sh
      ```
    - Enter the name of the stack to be created
    
#### Stack deletion
1. To delete lambda cicd stack:
    - Run the following script in terminal
      ```
      bash csye6225-lambda-aws-terminate-cicd-stack.sh
      ```
    - Enter the name of the stack to be deleted

2. To delete lambda serverless stack:
    - Run the following script in terminal
      ```
      bash csye6225-lambda-aws-terminate-serverless-stack.sh
      ```
    - Enter the name of the stack to be deleted
