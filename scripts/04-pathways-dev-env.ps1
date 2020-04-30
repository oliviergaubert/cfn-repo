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

#$CFN_TEMPLATE_NET = "cfn-app-dev-network-jg.yaml" => Private Certificate
$CFN_TEMPLATE_NET = "cfn-app-dev-network.yaml"
$CFN_TEMPLATE_FUNCTION = "cfn-account-func.yaml"
$CFN_TEMPLATE_ACCOUNT = "ssm_role.yaml"
$CFN_TEMPLATE_ENV = "cfn-app-dev-env-jg.yaml"

$REGION = "eu-west-2"
$PROFILE = "pathways-sandpit"



###################################### Environment Creation ######################################
aws s3 cp --recursive ..\cloudformation\templates s3://$S3_BUCKET/templates --region $REGION --profile $PROFILE
aws s3 cp ..\cloudformation\$AppEnv\$CFN_TEMPLATE_ENV s3://$S3_BUCKET --region $REGION --profile $PROFILE

Write-Output 'Deleting the stack...'
aws cloudformation delete-stack --region $REGION --profile $PROFILE --stack-name $EnvStackName
Write-Output 'Waiting for the stack to be deleted, this may take a few minutes...'
aws cloudformation wait stack-delete-complete --region $REGION --profile $PROFILE --stack-name $EnvStackName
Write-Output 'Done'

Write-Output 'Validating template...'
aws cloudformation validate-template --template-url https://$S3_BUCKET.s3.$REGION.amazonaws.com/$CFN_TEMPLATE_ENV

Write-Output 'Creating stack...'
aws cloudformation create-stack --region $REGION --profile $PROFILE --stack-name $EnvStackName --template-url https://$S3_BUCKET.s3.$REGION.amazonaws.com/$CFN_TEMPLATE_ENV --parameters ParameterKey=DBName,ParameterValue=$DBName ParameterKey=ClusterName,ParameterValue=$EnvStackName ParameterKey=LbName,ParameterValue=$EnvStackName ParameterKey=TemplateBucket,ParameterValue=$S3_BUCKET ParameterKey=EnvironmentInstance,ParameterValue=$AppEnv --capabilities CAPABILITY_NAMED_IAM, CAPABILITY_AUTO_EXPAND
Write-Output 'Awaiting completion of the following stacking: ' $EnvStackName
aws cloudformation describe-stack-events --stack-name $EnvStackName --region $REGION --profile $PROFILE
aws cloudformation wait stack-create-complete --stack-name $EnvStackName --region $REGION --profile $PROFILE

##################################################################################################