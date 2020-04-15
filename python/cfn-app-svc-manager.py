#!/usr/bin/python3

import argparse
import yaml
import json
import subprocess

class cfnAppServiceManager:
    def __init__(self, **kwargs)
        self.__dict__.update(kwargs)

    def buildPropertiesDict(self):
        with open("mm-mfa-properties.yaml", 'r') as stream:
            try:
                propd = dict.update((yaml.safe_load(stream)))
            except yaml.YAMLError as exc:
                print(exc)

        return propd


def main():
    parser = argparse.ArgumentParser(description='service manager parameters')
    parser.add_argument('-ji', '--jira_issue', type=str, default=None, help='jira issue reference')
    parser.add_argument('-rv', '--release_version', type=str, default=None, help='release version')
    parser.add_argument('-et', '--email_to', nargs='*', default=None, help='email recipients')

    args = parser.parse_args()

    params = vars(args)

    c = cfnAppServiceManager(**params)
    param1 = c.function1_name()
    param2 = c.function2_name(param1)

if __name__ == '__main__':
    main()
