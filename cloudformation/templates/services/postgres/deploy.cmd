aws s3 cp .\rds.yaml s3://rds-testing-cf --region eu-west-2 --profile i2n-engineering
aws s3 cp ..\..\..\..\..\target\RDSManager-1.0-SNAPSHOT-jar-with-dependencies.jar s3://rds-testing-cf/rdsmanager.jar

echo 'Deleting the stack...'
aws cloudformation delete-stack  --region eu-west-2 --profile i2n-engineering --stack-name Lambda-DEV
echo 'Waiting for the stack to be deleted, this may take a few minutes...'
aws cloudformation wait stack-delete-complete --region eu-west-2 --profile i2n-engineering --stack-name Lambda-DEV
echo 'Done'

aws cloudformation validate-template --template-url https://rds-testing-cf.s3.eu-west-2.amazonaws.com/rds.yaml --region eu-west-2 --profile i2n-engineering
aws cloudformation create-stack --region eu-west-2 --profile i2n-engineering --stack-name Lambda-DEV --template-url https://rds-testing-cf.s3.eu-west-2.amazonaws.com/rds.yaml --parameters  ParameterKey=TemplateBucket,ParameterValue=rds-testing-cf ParameterKey=EnvironmentInstance,ParameterValue=DEV ParameterKey=EnvironmentInstance,ParameterValue=DEV ParameterKey=VPCPrivateSubnets,ParameterValue=subnet-02ce69c3439711366 ParameterKey=VPCSecurityGroups,ParameterValue=sg-0247b436b0377a758 ParameterKey=DBName,ParameterValue=DEV --capabilities CAPABILITY_NAMED_IAM --disable-rollback
aws cloudformation describe-stack-events --stack-name Lambda-DEV --region eu-west-2 --profile i2n-engineering