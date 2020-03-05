#!/bin/bash

set -o errexit -o xtrace

app_name="media-manager"
app_env="dev"
stackname="pathways-${app_name}-${app_env}-ecs-cluster"
bucket="pathways-devops-cf-templates"
vpc_Id="vpc-0002797909c7ed414"
subnets="subnet-0706ae134dda0d439,subnet-07f8a96fea0347273"
vpccidr="10.210.0.0/16"
#repo="pathways-devops-cf-templates"

aws cloudformation deploy --stack-name $stackname --template-file ./templates/ecs-cluster.yaml --capabilities CAPABILITY_NAMED_IAM --parameter-overrides VpcId=$vpc_Id TemplateBucket=$bucket Subnets=$subnets VpcCIDR=$vpccidr

#aws cloudformation deploy --stack-name $stackname --template-file ./templates/ecs-cluster.yaml --capabilities CAPABILITY_NAMED_IAM --parameter-overrides VpcId=$vpc_Id TemplateBucket=$bucket Subnets=$subnets VpcCIDR=$vpccidr ApplicationName=$app_name
