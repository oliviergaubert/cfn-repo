import argparse
import json

import boto3
import requests


class GetStackOutputs:
    def __init__(self, **kwargs):
        self.__dict__.update(kwargs)
        self.region = self.region
        self.stack_name = self.stack_name
        self.profile = self.profile
        self.circle_ci_token = self.circle_ci_token

    def ConnectToAWS(self):

        aws_keys = {}
        client = boto3.session.Session(profile_name=self.profile).client(
            service_name='cloudformation',
            region_name=self.region)

        stacks = client.describe_stacks(StackName=self.stack_name)

        if len(stacks) != 0:

            for output in stacks['Stacks'][0]['Outputs']:
                aws_keys[output.get('OutputKey')] = output.get('OutputValue')

        else:
            print("Unable to find stack")

        return aws_keys

    def CreateEnvVariables(self, aws_keys):
        url = 'https://circleci.com/api/v2/project/aws-testing/envvar' \
            + self.circle_ci_token

        for env in aws_keys:
            payload = json.dumps({'name': env, 'value': aws_keys[env]})
            r = requests.post(url, data=payload)
            print(r.status_code)


def main():
    parser = argparse.ArgumentParser(description='service manager parameters')
    parser.add_argument('--region', '-r', type=str, default="eu-west-2", help='AWS Region where stack located')
    parser.add_argument('--stack_name', '-sn', type=str, default=None, help='Stack Name')
    parser.add_argument('--profile', '-p', type=str, default=None, help='AWS profile')
    parser.add_argument('--circle_ci_token', '-cct', type=str, default=None, help='CircleCI Access Token')

    args = parser.parse_args()

    params = vars(args)

    c = GetStackOutputs(**params)
    aws_keys = c.ConnectToAWS()
    g = c.CreateEnvVariables(aws_keys)


if __name__ == '__main__':
    main()
