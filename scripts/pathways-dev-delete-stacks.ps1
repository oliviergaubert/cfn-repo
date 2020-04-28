$S3_BUCKET = "aws-cloud-formation-repo-engineering"
$NETStackName = "pathways-dev-net"
$AccountStackName = "pathways-dev-iam"
$EnvStackName = "pathways-mm-app-dev-env"
$FunctionStackName = "pathways-mm-app-dev-func"

$REGION = "eu-west-2"
$PROFILE = "i2n-engineering"

###################################### Delete Environment ######################################
Write-Output 'Deleting the stack...'
aws cloudformation delete-stack --region $REGION --profile $PROFILE --stack-name $EnvStackName
Write-Output 'Waiting for the stack to be deleted, this may take a few minutes...'
aws cloudformation wait stack-delete-complete --region $REGION --profile $PROFILE --stack-name $EnvStackName
Write-Output 'Done'

###################################### Delete IAMs Users/Roles  ##############################
Write-Output 'Deleting the stack...'
aws cloudformation delete-stack --region $REGION --profile $PROFILE --stack-name $AccountStackName
Write-Output 'Waiting for the stack to be deleted, this may take a few minutes...'
aws cloudformation wait stack-delete-complete --region $REGION --profile $PROFILE --stack-name $AccountStackName
Write-Output 'Done'

###################################### Delete Function  ##############################

Write-Output 'Deleting the stack...'
aws cloudformation delete-stack --region $REGION --profile $PROFILE --stack-name $FunctionStackName
Write-Output 'Waiting for the stack to be deleted, this may take a few minutes...'
aws cloudformation wait stack-delete-complete --region $REGION --profile $PROFILE --stack-name $FunctionStackName
Write-Output 'Done'

###################################### Network ###################################################
Write-Output 'Deleting the stack...'
aws cloudformation delete-stack --region $REGION --profile $PROFILE --stack-name $NETStackName
Write-Output 'Waiting for the stack to be deleted, this may take a few minutes...'
aws cloudformation wait stack-delete-complete --region $REGION --profile $PROFILE --stack-name $NETStackName
Write-Output 'Done'

