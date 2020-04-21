aws s3 cp .\mongo.yaml s3://aws-cloud-formation-repo-engineering  --region eu-west-2 --profile i2n-engineering
aws s3 cp .\mongodb-accounts.yaml s3://aws-cloud-formation-repo-engineering  --region eu-west-2 --profile i2n-engineering
aws s3 cp .\mongodb-lambda-deploy.yaml s3://aws-cloud-formation-repo-engineering  --region eu-west-2 --profile i2n-engineering
aws s3 cp .\mongodb-single-node.yaml s3://aws-cloud-formation-repo-engineering  --region eu-west-2 --profile i2n-engineering

echo 'Deleting the stack...'
aws cloudformation delete-stack  --region eu-west-2 --profile i2n-engineering --stack-name testing-DEV
echo 'Waiting for the stack to be deleted, this may take a few minutes...'
aws cloudformation wait stack-delete-complete --region eu-west-2 --profile i2n-engineering --stack-name testing-DEV
echo 'Done'

aws cloudformation validate-template --template-url https://aws-cloud-formation-repo-engineering.s3.eu-west-2.amazonaws.com/mongo.yaml
aws cloudformation create-stack --region eu-west-2 --profile i2n-engineering --stack-name testing-DEV --template-url https://aws-cloud-formation-repo-engineering.s3.eu-west-2.amazonaws.com/mongo.yaml --parameters ParameterKey=TemplateBucket,ParameterValue=aws-cloud-formation-repo-engineering ParameterKey=EnvironmentInstance,ParameterValue=DEV --capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND --disable-rollback
aws cloudformation describe-stack-events --stack-name testing-DEV --region eu-west-2 --profile i2n-engineering