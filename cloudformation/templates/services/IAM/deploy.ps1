
$S3_BUCKET = "aws-cloud-formation-repo-engineering"
$REGION = "eu-west-2"
$CFN_TEMPLATE_TESTING = "circleci_deployment_role.yaml"
$PROFILE = "i2n-engineering"
$INSPECTOR_STACK_NAME = "CircleCI-Testing"

## ------- INSPECTORDB Deployment ---------------------------

aws s3 cp .\$CFN_TEMPLATE_TESTING s3://$S3_BUCKET --region $REGION --profile $PROFILE

Write-Output 'Deleting the stack...'
aws cloudformation delete-stack --region $REGION --profile $PROFILE --stack-name $INSPECTOR_STACK_NAME
Write-Output 'Waiting for the stack to be deleted, this may take a few minutes...'
aws cloudformation wait stack-delete-complete --region $REGION --profile $PROFILE --stack-name $INSPECTOR_STACK_NAME
Write-Output 'Done'

aws cloudformation validate-template --template-url https://$S3_BUCKET.s3.$REGION.amazonaws.com/$CFN_TEMPLATE_TESTING
aws cloudformation create-stack --region $REGION --profile $PROFILE --stack-name $INSPECTOR_STACK_NAME --template-url https://$S3_BUCKET.s3.$REGION.amazonaws.com/$CFN_TEMPLATE_TESTING --capabilities CAPABILITY_NAMED_IAM --disable-rollback
aws cloudformation describe-stack-events --stack-name $INSPECTOR_STACK_NAME --region $REGION --profile $PROFILE

## ----------- Complete -------------------------------------------
