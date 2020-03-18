#!/bin/bash

set -o errexit -o xtrace

stackName="pathways-dev-mm-app-svc-b"
bucket="pathways-devops-cf-templates"
GitHubRepo="app-service-b"
GitHubRepo="develop"

aws s3 cp ${stackName}.yaml "s3://${bucket}" --acl public-read
aws s3api put-bucket-versioning --bucket "${bucket}" --versioning-configuration Status=Enabled
aws cloudformation deploy --stack-name $stackName --template-file ${stackName}.yaml --capabilities CAPABILITY_NAMED_IAM --parameter-overrides TemplateBucket=$bucket GitHubRepo=$GitHubRepo GitHubBranch=$GitHubBranch ArtifactBucketName=$stackName

