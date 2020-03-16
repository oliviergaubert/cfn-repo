#!/bin/bash

set -o errexit -o xtrace

bucket="pathways-devops-cf-templates"
masterTemplate="pathways-mm-app-dev-svc"

zip deploy/templates.zip ${stackname}.yaml templates/*
aws s3 cp deploy/templates.zip "s3://${bucket}" --acl public-read

aws s3 cp --recursive templates "s3://${bucket}/templates" --acl public-read
aws s3api put-bucket-versioning --bucket "${bucket}" --versioning-configuration Status=Enabled

