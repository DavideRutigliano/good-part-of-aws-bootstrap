#!/bin/bash -xe

# Makes sure any user-specific software that we’ve installed (e.g., npm via nvm) is available.
source /home/ec2-user/.bash_profile

# Changes into the working directory in which our application expects to be run.
cd /home/ec2-user/app/release

# Query the EC2 metadata service for this instance's region
export REGION=`curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq .region -r`

# Query the EC2 metadata service for this instance's instance-id
export INSTANCE_ID=`curl -s http://169.254.169.254/latest/meta-data/instance-id`

# Query EC2 describeTags method and pull our the CFN Logical ID for this instance
export STACK_NAME=`aws --region $REGION ec2 describe-tags \
  --filters "Name=resource-id,Values=${INSTANCE_ID}" \
            "Name=key,Values=aws:cloudformation:stack-name" \
  | jq -r ".Tags[0].Value"`

# Runs the start script we put in package.json.
npm run start