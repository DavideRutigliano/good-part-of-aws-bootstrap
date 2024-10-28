#!/bin/bash
REGION=us-east-1
CLI_PROFILE=awsbootstrap
STACK_NAME=good-part-of-aws-bootstrap

# Delete the CloudFormation stack
echo -e "\n\n=========== Deleting stack ==========="
aws cloudformation delete-stack \
    --region $REGION \
    --profile $CLI_PROFILE \
    --stack-name $STACK_NAME
