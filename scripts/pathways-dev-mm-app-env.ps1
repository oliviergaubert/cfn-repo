$StackName = "pathways-mm-app-dev-env"
$Bucket = "pathways-devops-cf-templates"
$AppEnv = "dev"
$REGION = "eu-west-2"
$PROFILE = "i2n-engineering"
$DBName = "pathwaysMmAppDevEnv"

aws s3 cp ./$AppEnv/$stackName.yaml "s3://${bucket}"
aws s3 cp --recursive templates "s3://${bucket}/templates"
aws s3api put-bucket-versioning --bucket $bucket --versioning-configuration Status=Enabled

Write-Output 'Deleting the stack...'
aws cloudformation delete-stack --region $REGION --profile $PROFILE --stack-name $stackName
Write-Output 'Waiting for the stack to be deleted, this may take a few minutes...'
aws cloudformation wait stack-delete-complete --region $REGION --profile $PROFILE --stack-name $stackName
Write-Output 'Done'

Write-Output 'Validating template...'
aws cloudformation validate-template --template-url https://$bucket.s3.$REGION.amazonaws.com/$stackName.yaml

Write-Output 'Creating stack...'
aws cloudformation create-stack --region $REGION --profile i2n-engineering --stack-name $stackName --template-url https://$bucket.s3.$REGION.amazonaws.com/$stackName.yaml --parameters ParameterKey=DBName,ParameterValue=$DBName ParameterKey=ClusterName,ParameterValue=$stackName ParameterKey=LbName,ParameterValue=$stackName ParameterKey=TemplateBucket,ParameterValue=$bucket --capabilities CAPABILITY_NAMED_IAM
aws cloudformation describe-stack-events --stack-name $stackName --region $REGION --profile $PROFILE