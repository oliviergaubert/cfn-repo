#!/bin/bash

#set -o errexit -o xtrace

app_name="media-manager"
app_env="dev"
stack_name="pathways-${app_name}-${app_env}"

#echo "decribe stack:" $stack_name
#aws cloudformation describe-stacks --stack-name $stack_name

echo "retrieve stack ID for stack:" $stack_name
aws cloudformation describe-stacks --stack-name $stack_name --query "Stacks[*].[StackId]" --output text 
#stack_id=`aws cloudformation describe-stacks --stack-name $stack_name --query "Stacks[*].[StackId]" --output text` 
echo $stack_id

#echo "list stacks..."
#aws cloudformation list-stacks --stack-status-filter CREATE_COMPLETE
#aws cloudformation list-stacks --stack-status-filter CREATE_COMPLETE --query 'StackSummaries[*].[StackId, StackName, ParentId]'
#aws cloudformation list-stacks --stack-status-filter CREATE_COMPLETE --query 'StackSummaries[?ParentId=="arn:aws:cloudformation:eu-west-2:541043622927:stack/pathways-media-manager-dev/b3a04590-3645-11ea-9697-029db6d88004"].StackName' 

vpc_stack_name="pathways-media-manager-dev-VPC-162FCGVV7E0X7"
echo "decribe stack:" $vpc_stack_name
aws cloudformation describe-stacks --stack-name $vpc_stack_name
