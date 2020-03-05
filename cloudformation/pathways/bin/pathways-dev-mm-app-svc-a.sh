#!/bin/bash

set -o errexit -o xtrace

AppServiceName="pathways-dev-mm-app-svc-a"
CodeRepo="app-service-a"
CodeRepoBranch="develop"
AppServiceNamespaceName="dev-mm-app-svc-a-disc"
TemplateBucket="pathways-devops-cf-templates"

aws s3 cp ./dev/pathways-mm-app-dev-svc.yaml "s3://${TemplateBucket}" --acl public-read
aws s3api put-bucket-versioning --bucket "${TemplateBucket}" --versioning-configuration Status=Enabled
aws cloudformation deploy --stack-name $AppServiceName --template-file ./dev/pathways-mm-app-dev-svc.yaml --capabilities CAPABILITY_NAMED_IAM --parameter-overrides TemplateBucket=$TemplateBucket CodeRepo=$CodeRepo CodeRepoBranch=$CodeRepoBranch ArtifactBucketName=$AppServiceName NamespaceName=$AppServiceNamespaceName
