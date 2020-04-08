Bucket="pathways-devops-cf-templates"
$stackname="pathways-dev-vpc"
$appenv="dev"

aws s3 cp ./$appenv/cfn-app-dev-vpc.yaml "s3://$bucket"
aws s3api put-bucket-versioning --bucket "$bucket" --versioning-configuration Status=Enabled
aws cloudformation deploy --stack-name $stackname --template-file ./${appenv}/cfn-app-dev-vpc.yaml --capabilities CAPABILITY_NAMED_IAM --parameter-overrides TemplateBucket=$bucket
