#!/bin/bash
REGION=eu-central-1
CLI_PROFILE=awsbootstrap
STACK_NAME=good-part-of-aws-bootstrap

AWS_ACCOUNT_ID=`aws sts get-caller-identity --profile $CLI_PROFILE --query "Account" --output text`
CODEPIPELINE_BUCKET="codepipeline-$REGION-$AWS_ACCOUNT_ID"
CFN_BUCKET="cfn-$REGION-$AWS_ACCOUNT_ID"

# Empty s3 bucket
echo -e "\n\n=========== Emptying s3 buckets ==========="
aws s3 rm s3://$CODEPIPELINE_BUCKET --recursive --profile $CLI_PROFILE
aws s3 rm s3://$CFN_BUCKET --recursive --profile $CLI_PROFILE

# Delete the CloudFormation setup stack
echo -e "\n\n=========== Deleting setup stack ==========="
aws cloudformation delete-stack \
    --profile $CLI_PROFILE \
    --region $REGION \
    --stack-name $STACK_NAME-setup

# Delete the CloudFormation stack
echo -e "\n\n=========== Deleting stack ==========="
aws cloudformation delete-stack \
    --profile $CLI_PROFILE \
    --region $REGION \
    --stack-name $STACK_NAME
