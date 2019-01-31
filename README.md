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
