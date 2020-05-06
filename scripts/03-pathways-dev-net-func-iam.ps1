#################################### Change me #####################################################

$S3_BUCKET = "aws-cloud-formation-repo-engineering-1"
$NETStackName = "pathways-dev-net-1"
$AccountStackName = "pathways-dev-iam-1"
$EnvStackName = "pathways-mm-app-dev-env-1"
$FuncationStackName = "pathways-mm-app-dev-func-1"

$AppEnv = "dev"
$DBName = "pathwaysMmAppDevEnv1"
$NamespaceName= 'pathways-dev-testing-1'

###################################### Completed ###################################################

# $CFN_TEMPLATE_NET = "cfn-app-dev-network-jg.yaml" => Root CA/Private Certificate (root_ca.yaml)
$CFN_TEMPLATE_NET = "cfn-app-dev-network.yaml"
$CFN_TEMPLATE_FUNCTION = "cfn-account-func.yaml"
$CFN_TEMPLATE_ACCOUNT = "ssm_role.yaml"
# $CFN_TEMPLATE_ENV = "cfn-app-dev-env-jg.yaml" => Create ALB only (load-balancer-jg.yaml)
$CFN_TEMPLATE_ENV = "cfn-app-dev-env.yaml"

$REGION = "eu-west-2"
$PROFILE = "pathways-sandpit"


$VpcCIDR = "10.8.0.0/16"
$DMZSubnet1CIDR = "10.8.1.0/24"
$DMZSubnet2CIDR = "10.8.2.0/24"
$ECSSubnet1CIDR = "10.8.4.0/24"
$ECSSubnet2CIDR = "10.8.5.0/24"
$ECSSubnet3CIDR = "10.8.6.0/24"
$ServicesSubnet1CIDR = "10.8.10.0/24"
$ServicesSubnet2CIDR = "10.8.11.0/24"
$ServicesSubnet3CIDR = "10.8.12.0/24"
$RDSSubnet1CIDR = "10.8.20.0/24"
$RDSSubnet2CIDR = "10.8.21.0/24"
$RDSSubnet3CIDR = "10.8.22.0/24"
$MongoSubnet1CIDR = "10.8.30.0/24"
$MongoSubnet2CIDR = "10.8.31.0/24"
$MongoSubnet3CIDR = "10.8.32.0/24"

###################################### Network ###################################################

Write-Output 'Copying templete to S3...'
aws s3 cp ..\cloudformation\$AppEnv\$CFN_TEMPLATE_NET s3://$S3_BUCKET --region $REGION --profile $PROFILE
aws s3 cp --recursive ..\cloudformation\templates s3://$S3_BUCKET/templates --region $REGION --profile $PROFILE
aws s3 cp --recursive ..\cloudformation\lambda s3://$S3_BUCKET/lambda --region $REGION --profile $PROFILE

Write-Output 'Competeled copied'

Write-Output 'Deleting the stack...'
aws cloudformation delete-stack --region $REGION --profile $PROFILE --stack-name $NETStackName
Write-Output 'Waiting for the stack to be deleted, this may take a few minutes...'
aws cloudformation wait stack-delete-complete --region $REGION --profile $PROFILE --stack-name $NETStackName
Write-Output 'Delete completed'

Write-Output 'Creating the stack...'
aws cloudformation create-stack --region $REGION --profile $PROFILE --stack-name $NETStackName --template-url https://$S3_BUCKET.s3.$REGION.amazonaws.com/$CFN_TEMPLATE_NET --capabilities CAPABILITY_NAMED_IAM --parameters ParameterKey=TemplateBucket,ParameterValue=$S3_BUCKET ParameterKey=EnvironmentInstance,ParameterValue=$AppEnv ParameterKey=StackName,ParameterValue=$NETStackName ParameterKey=VpcCIDR,ParameterValue=$VpcCIDR ParameterKey=DMZSubnet1CIDR,ParameterValue=$DMZSubnet1CIDR ParameterKey=DMZSubnet2CIDR,ParameterValue=$DMZSubnet2CIDR  ParameterKey=ECSSubnet1CIDR,ParameterValue=$ECSSubnet1CIDR ParameterKey=ECSSubnet2CIDR,ParameterValue=$ECSSubnet2CIDR ParameterKey=ECSSubnet3CIDR,ParameterValue=$ECSSubnet3CIDR ParameterKey=ServicesSubnet1CIDR,ParameterValue=$ServicesSubnet1CIDR ParameterKey=ServicesSubnet2CIDR,ParameterValue=$ServicesSubnet2CIDR ParameterKey=ServicesSubnet3CIDR,ParameterValue=$ServicesSubnet3CIDR ParameterKey=RDSSubnet1CIDR,ParameterValue=$RDSSubnet1CIDR ParameterKey=RDSSubnet2CIDR,ParameterValue=$RDSSubnet2CIDR ParameterKey=RDSSubnet3CIDR,ParameterValue=$RDSSubnet3CIDR ParameterKey=MongoSubnet1CIDR,ParameterValue=$MongoSubnet1CIDR ParameterKey=MongoSubnet2CIDR,ParameterValue=$MongoSubnet2CIDR ParameterKey=MongoSubnet3CIDR,ParameterValue=$MongoSubnet3CIDR ParameterKey=NamespaceName,ParameterValue=$NamespaceName
Write-Output 'Awaiting completion of the following stacking: ' $NETStackName
aws cloudformation wait stack-create-complete --stack-name $NETStackName --region $REGION --profile $PROFILE
Write-Output 'Stacked completed'

aws ecs put-account-setting-default --name awsvpcTrunking --value enabled --region $REGION --profile $PROFILE

###################################### Function Creation ##############################

aws s3 cp ..\cloudformation\$AppEnv\$CFN_TEMPLATE_FUNCTION s3://$S3_BUCKET --region $REGION --profile $PROFILE

Write-Output 'Deleting the stack...'
aws cloudformation delete-stack --region $REGION --profile $PROFILE --stack-name $FunctionStackName
Write-Output 'Waiting for the stack to be deleted, this may take a few minutes...'
aws cloudformation wait stack-delete-complete --region $REGION --profile $PROFILE --stack-name $FunctionStackName
Write-Output 'Done'

aws cloudformation validate-template --template-url https://$S3_BUCKET.s3.$REGION.amazonaws.com/$CFN_TEMPLATE_FUNCTION
aws cloudformation create-stack --region $REGION --profile $PROFILE --stack-name $FunctionStackName --template-url https://$S3_BUCKET.s3.$REGION.amazonaws.com/$CFN_TEMPLATE_FUNCTION --capabilities CAPABILITY_NAMED_IAM --parameters ParameterKey=TemplateBucket,ParameterValue=$S3_BUCKET ParameterKey=EnvironmentInstance,ParameterValue=$AppEnv
aws cloudformation describe-stack-events --stack-name $FunctionStackName  --region $REGION --profile $PROFILE
Write-Output 'Awaiting completion of the following stacking:' $FunctionStackName
aws cloudformation wait stack-create-complete --stack-name $FunctionStackName --region $REGION --profile $PROFILE

##################################################################################################

aws s3 cp ..\cloudformation\templates\services\IAM\$CFN_TEMPLATE_ACCOUNT s3://$S3_BUCKET --region $REGION --profile $PROFILE

Write-Output 'Deleting the stack...'
aws cloudformation delete-stack --region $REGION --profile $PROFILE --stack-name $AccountStackName
Write-Output 'Waiting for the stack to be deleted, this may take a few minutes...'
aws cloudformation wait stack-delete-complete --region $REGION --profile $PROFILE --stack-name $AccountStackName
Write-Output 'Done'

aws cloudformation validate-template --template-url https://$S3_BUCKET.s3.$REGION.amazonaws.com/$CFN_TEMPLATE_ACCOUNT
aws cloudformation create-stack --region $REGION --profile $PROFILE --stack-name $AccountStackName --template-url https://$S3_BUCKET.s3.$REGION.amazonaws.com/$CFN_TEMPLATE_ACCOUNT --capabilities CAPABILITY_NAMED_IAM
aws cloudformation describe-stack-events --stack-name $AccountStackName  --region $REGION --profile $PROFILE
Write-Output 'Awaiting completion of the following stacking:' $AccountStackName
aws cloudformation wait stack-create-complete --stack-name $AccountStackName --region $REGION --profile $PROFILE

##################################################################################################
