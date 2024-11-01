#!/bin/bash
REGION=eu-central-1
CLI_PROFILE=awsbootstrap
STACK_NAME=good-part-of-aws-bootstrap
EC2_INSTANCE_TYPE=t2.micro

GH_OWNER=DavideRutigliano
GH_REPO=good-part-of-aws-bootstrap
GH_BRANCH=main
GH_ACCESS_TOKEN=$(cat ~/.github/aws-bootstrap-demo-token)

AWS_ACCOUNT_ID=`aws sts get-caller-identity --profile $CLI_PROFILE --query "Account" --output text`
CODEPIPELINE_BUCKET="codepipeline-$REGION-$AWS_ACCOUNT_ID"

# Deploy the CloudFormation template for CodePipeline S3 bucket
echo -e "\n\n=========== Deploying setup.yaml ==========="
aws cloudformation deploy \
    --profile $CLI_PROFILE \
    --stack-name $STACK_NAME-setup \
    --region $REGION \
    --template-file cft/setup.yaml \
    --no-fail-on-empty-changeset \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides \
    CodePipelineBucket=$CODEPIPELINE_BUCKET

# Deploy the CloudFormation template for the app infra
echo -e "\n\n=========== Deploying main.yaml ==========="
aws cloudformation deploy \
    --profile $CLI_PROFILE \
    --stack-name $STACK_NAME \
    --region $REGION \
    --template-file cft/main.yaml \
    --no-fail-on-empty-changeset \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides \
        EC2InstanceType=$EC2_INSTANCE_TYPE \
        GitHubOwner=$GH_OWNER \
        GitHubRepo=$GH_REPO \
        GitHubBranch=$GH_BRANCH \
        GitHubPersonalAccessToken=$GH_ACCESS_TOKEN \
        CodePipelineBucket=$CODEPIPELINE_BUCKET

# If the deploy succeeded, show the DNS name of the created instance
if [ $? -eq 0 ]; then
aws cloudformation list-exports \
    --profile awsbootstrap \
    --query "Exports[?Name=='InstanceEndpoint'].Value"
fi