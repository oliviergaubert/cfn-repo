#!/bin/bash

set -o errexit -o xtrace

aws s3 cp --recursive dev "s3://${bucket}/dev" --acl public-read
aws s3 cp --recursive templates "s3://${bucket}/templates" --acl public-read

