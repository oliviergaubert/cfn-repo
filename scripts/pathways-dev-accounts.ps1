$S3_BUCKET = "pathways-devops-cf-templates"
$REGION = "eu-west-2"
$CFN_TEMPLATE_SSM = "ssm_role.yaml"
$PROFILE = "i2n-engineering"
$SSM_STACK_NAME = "SSM-DEV-ACCOUNT"

## ------- SSM Role Createion ---------------------------

aws s3 cp .\$CFN_TEMPLATE_SSM s3://$S3_BUCKET --region $REGION --profile $PROFILE

Write-Output 'Deleting the stack...'
aws cloudformation delete-stack --region $REGION --profile $PROFILE --stack-name $SSM_STACK_NAME
Write-Output 'Waiting for the stack to be deleted, this may take a few minutes...'
aws cloudformation wait stack-delete-complete --region $REGION --profile $PROFILE --stack-name $SSM_STACK_NAME
Write-Output 'Done'

aws cloudformation validate-template --template-url https://$S3_BUCKET.s3.$REGION.amazonaws.com/$CFN_TEMPLATE_SSM
aws cloudformation create-stack --region $REGION --profile $PROFILE --stack-name $SSM_STACK_NAME --template-url https://$S3_BUCKET.s3.$REGION.amazonaws.com/$CFN_TEMPLATE_SSM --capabilities CAPABILITY_NAMED_IAM
aws cloudformation describe-stack-events --stack-name $SSM_STACK_NAME  --region $REGION --profile $PROFILE
Write-Output 'Awaiting completion of the following stacking: $SSM_STACK_NAME'
aws cloudformation wait stack-create-complete --stack-name $SSM_STACK_NAME --region $REGION --profile $PROFILE