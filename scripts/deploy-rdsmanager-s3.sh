#!/bin/bash

set -o errexit -o xtrace

bucket="rdsmanager"

aws s3 cp "/home/alex.richardson/source/codecommit/rdsmanager/target/RDSManager-1.0-SNAPSHOT.jar" "s3://${bucket}" --acl public-read
aws s3api put-bucket-versioning --bucket "${bucket}" --versioning-configuration Status=Enabled

