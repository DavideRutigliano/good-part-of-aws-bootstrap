#!/bin/bash -xe

# Makes sure any user-specific software that we’ve installed (e.g., npm via nvm) is available.
source /home/ec2-user/.bash_profile

# Changes into the working directory in which our application expects to be run.
cd /home/ec2-user/app/release

# Runs the start script we put in package.json.
npm run start