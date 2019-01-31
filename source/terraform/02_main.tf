resource "aws_iam_role" "lambda" {
  name = "${var.project}-${var.stage}-${var.obcon_module_name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = "${aws_iam_role.lambda.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "lambda" {
  s3_bucket     = "${var.obcon_module_bucket}"
  s3_key        = "${var.obcon_module_name}/${var.obcon_module_name}_${var.obcon_module_version}_code.zip"
  function_name = "${var.project}-${var.stage}-${var.obcon_module_name}"
  role          = "${aws_iam_role.lambda.arn}"
  handler       = "main.handler"
  runtime       = "python3.6"

  environment {
    variables = {
      webhook = "${var.webhook}"
    }
  }
}

data "aws_sns_topic" "topic" {
  name = "${var.project}-${var.stage}-${var.obcon_module_name}"
}

resource "aws_sns_topic_subscription" "subscription" {
  topic_arn = "${aws_sns_topic.topic.arn}"
  protocol  = "lambda"
  endpoint  = "${aws_lambda_function.lambda.arn}"
}

resource "aws_lambda_permission" "sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda.function_name}"
  principal     = "sns.amazonaws.com"
  source_arn    = "${aws_sns_topic.topic.arn}"
}
