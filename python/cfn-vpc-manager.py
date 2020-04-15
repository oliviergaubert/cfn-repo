#!/usr/bin/python3

import argparse
import boto3
import yaml
import json
import subprocess

class cfnVpcManager:
    def __init__(self, **kwargs):
        self.__dict__.update(kwargs)

        """ cloudformation constants """
        self.cfn_temp_bckt  = "pathways-devops-cf-templates"

        """ application config files """
        self.vpc_zone       = self.zone
        self.app_config_dir = "application-config"
        self.app_config_all = self.app_config_dir + "/all/"
        self.vpc_config_fn  = self.vpc_zone + "-vpc-properties.yaml"
        self.vpc_config_pth = self.app_config_all + self.vpc_config_fn 

    """ retrieve properties from app config files """
    def buildPropertiesDict(self):
        with open(self.vpc_config_pth, 'r') as stream:
            try:
                propd = yaml.safe_load(stream)
            except yaml.YAMLError as exc:
                print(exc)
        
        # print(propd)
        # print(propd['vpc-name'])

        return propd

    """ connection is managed via boto3 """
    def checkVpcExists(self, propd):  
        vpc_name=propd['vpc-name']

        client = boto3.client('ec2',region_name='eu-west-2')
        response = client.describe_vpcs(Filters=[
            {'Name': 'tag:Name', 'Values': [vpc_name,]}])
        resp = response['Vpcs']

        if resp:
            print(resp)
        else:
            print('No vpcs found')

        return

    """ upload associated templates to S3 """


    """ use aws cloudformation create-stack """
    def createVpcAwsCloudFormation(self, propd):
        vpcchk = self.checkVpcExists(propd)
        """ implement condition around vpcchk """
        # this to be done using boto3 directly

        # breaking down aws cmd elements into isolated components for dynamic population (propd)
        """ build aws command to execute """
        awscfn  = "aws cloudformation create-stack"
        region  = "eu-west-2"
        profile = "i2n-engineering" 
        stacknm = "stackName"
        tempurl = "https://" + self.cfn_temp_bckt + ".s3.eu-west-2.amazonaws.com/dev/cfn-app-dev-vpc.yaml"
        params  = "ParameterKey=TemplateBucket,ParameterValue=" + self.cfn_temp_bckt + \
                  " ParameterKey=Name,ParameterValue=" + propd['vpc-name']

        awscmd  = awscfn + " --region" + region + " --profile " + profile + " --stack-name " + \
                  stacknm + " --template-url " + tempurl +  " --parameters " + params + \
                  " --capabilities CAPABILITY_NAMED_IAM"
        
        print("cmd:", awscmd)
        #awsproc = subprocess.aws cloudformation create-stack
        #awsout  = awsproc.stdout 
       
        return


""" NOTE: arguments can be expanded to allow for customized names vs those deduced, as and when this
    is to be employed, will be depend on specific use case frequency/exceptions/etc... """

def main():
    parser = argparse.ArgumentParser(description='vpc manager parameters')
    parser.add_argument('-zn', '--zone', type=str, default="dev", help='vpc zone')

    args = parser.parse_args()
    params = vars(args)

    c = cfnVpcManager(**params)
    propd = c.buildPropertiesDict()
    c.createVpcAwsCloudFormation(propd)

if __name__ == '__main__':
    main()

# params for env 
# params  = "ParameterKey=DBName,ParameterValue=" + pathwaysMmAppDevEn + " " + \
#           "ParameterKey=ClusterName,ParameterValue=" + stacknm + " " + \
#           "ParameterKey=LbName,ParameterValue=" + stacknm + " " + \
#           "ParameterKey=TemplateBucket,ParameterValue=" + self.cfn_temp_bckt

# post creation, for validation, if error, implement below cmd
# aws cloudformation describe-stack-events --stack-name ${stackName} --region eu-west-2 --profile i2n-engineering 
