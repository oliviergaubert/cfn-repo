#!/bin/bash

set -o errexit -o xtrace

AppServiceName="pathways-mm-app-dev-svc-dns"
AppServiceNamespaceName="dev-mm-app-svc-a-disc"
TemplateBucket="pathways-devops-cf-templates"

aws s3 cp ./dev/pathways-mm-app-dev-svc-dns.yaml "s3://${TemplateBucket}" --acl public-read
aws s3api put-bucket-versioning --bucket "${TemplateBucket}" --versioning-configuration Status=Enabled
aws cloudformation deploy --stack-name $AppServiceName --template-file ./dev/pathways-mm-app-dev-svc-dns.yaml --capabilities CAPABILITY_NAMED_IAM --parameter-overrides NamespaceName=$AppServiceNamespaceName

