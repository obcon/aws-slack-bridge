# aws-slack-bridge

this modules creates a slack-bridge lambda function with an sns-topic.
can be integrated in other lambdas or cloudwatch alarms


```
# #####################################################################################################################################
#
# 01_provider.tf
#
# #####################################################################################################################################

provider "aws" {
  region     = "eu-central-1"
  profile    = "<PROFILE_NAME>"
}
```





```
# #####################################################################################################################################
#
# 02_variables.tf
#
# #####################################################################################################################################

variable "project" {
  default = "<PROJECT_NAME>"
}

variable "stage" {
  default = "<STAGE_NAME>"
}
```






```
# #####################################################################################################################################
#
# 03_main.tf
#
# #####################################################################################################################################

module "aws-slack-bridge" {
  source = "https://s3.eu-central-1.amazonaws.com/obcon-aws-modules/aws-slack-bridge/aws-slack-bridge_1.0_module.zip"

  project = "${var.project}"
  stage = "${var.stage}"

  webhook = "https://hooks.slack.com/services/<WEB_HOOK_ID>"
}
```

## if you want to integrate into your lambda function

```
import boto3
import json

client = boto3.client('lambda')

slack_message = {
    "username": "obcon",
    "channel": "#general",
    "icon_emoji": ":obcon:",
    "attachments": [
        {
            "title": "obcon status event",
            "text": "state"
        }
    ]
}

response = client.invoke(
    FunctionName='<PROJECT>-<STAGE>-aws-slack-bridge',
    InvocationType='Event',
    Payload=json.dumps(slack_message).encode()
)
