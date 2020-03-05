#!/bin/bash

set -o errexit -o xtrace

stackName="pathways-mm-app-dev-env"
bucket="pathways-devops-cf-templates"
appenv="dev"

aws s3 cp ./${appenv}/${stackName}.yaml "s3://${bucket}" --acl public-read
aws s3 cp --recursive templates "s3://${bucket}/templates" --acl public-read
aws s3api put-bucket-versioning --bucket "${bucket}" --versioning-configuration Status=Enabled

echo 'Deleting the stack...'
aws cloudformation delete-stack  --region eu-west-2 --profile i2n-engineering --stack-name $stackName
echo 'Waiting for the stack to be deleted, this may take a few minutes...'
aws cloudformation wait stack-delete-complete --region eu-west-2 --profile i2n-engineering --stack-name $stackName
echo '... stack deleted!'

echo 'Validating template...'
aws cloudformation validate-template --template-url https://${bucket}.s3.eu-west-2.amazonaws.com/${stackName}.yaml

echo 'Creating stack...'
aws cloudformation create-stack --region eu-west-2 --profile i2n-engineering --stack-name $stackName --template-url https://${bucket}.s3.eu-west-2.amazonaws.com/${stackName}.yaml --parameters ParameterKey=DBName,ParameterValue="pathwaysMmAppDevEnv" ParameterKey=ClusterName,ParameterValue=${stackName} ParameterKey=LbName,ParameterValue=${stackName} ParameterKey=TemplateBucket,ParameterValue=${bucket} --capabilities CAPABILITY_NAMED_IAM
aws cloudformation describe-stack-events --stack-name ${stackName} --region eu-west-2 --profile i2n-engineering

#aws cloudformation deploy --stack-name $stackName --template-file ${stackName}.yaml --capabilities CAPABILITY_NAMED_IAM --parameter-overrides TemplateBucket=$bucket ClusterName=$stackName LbName=$stackName

