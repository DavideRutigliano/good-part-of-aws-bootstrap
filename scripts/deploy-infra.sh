#!/bin/bash
REGION=eu-central-1
CLI_PROFILE=awsbootstrap
STACK_NAME=good-part-of-aws-bootstrap
EC2_INSTANCE_TYPE=t2.micro

AWS_ACCOUNT_ID=`aws sts get-caller-identity --profile $CLI_PROFILE --query "Account" --output text`
CODEPIPELINE_BUCKET="$STACK_NAME-$REGION-codepipeline-$AWS_ACCOUNT_ID"

echo -e "\n\n=========== Deploying setup.yml ==========="
aws cloudformation deploy \
    --profile $CLI_PROFILE \
    --stack-name $STACK_NAME-setup \
    --region $REGION \
    --template-file ctf/setup.yaml \
    --no-fail-on-empty-changeset \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides \
    CodePipelineBucket=$CODEPIPELINE_BUCKET

# Deploy the CloudFormation template
echo -e "\n\n=========== Deploying main.yml ==========="
aws cloudformation deploy \
    --profile $CLI_PROFILE \
    --stack-name $STACK_NAME \
    --region $REGION \
    --template-file ctf/main.yaml \
    --no-fail-on-empty-changeset \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides \
        EC2InstanceType=$EC2_INSTANCE_TYPE

# If the deploy succeeded, show the DNS name of the created instance
if [ $? -eq 0 ]; then
aws cloudformation list-exports \
    --profile awsbootstrap \
    --query "Exports[?Name=='InstanceEndpoint'].Value"
fi