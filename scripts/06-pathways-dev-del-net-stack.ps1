$S3_BUCKET = "aws-cloud-formation-repo-engineering-1"
$NETStackName = "pathways-dev-net-1"
$AccountStackName = "pathways-dev-iam-1"
$EnvStackName = "pathways-mm-app-dev-env-1"
$FunctionStackName = "pathways-mm-app-dev-func-1"

$REGION = "eu-west-2"
$PROFILE = "pathways-sandpit"

###################################### Network ###################################################
Write-Output 'Deleting the stack...'
aws cloudformation delete-stack --region $REGION --profile $PROFILE --stack-name $NETStackName
Write-Output 'Waiting for the stack to be deleted, this may take a few minutes...'
aws cloudformation wait stack-delete-complete --region $REGION --profile $PROFILE --stack-name $NETStackName
Write-Output 'Done'

