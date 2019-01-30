resource "aws_iam_role" "lambda" {
  name = "${var.project}-${var.stage}-${var.module}"

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


resource "aws_lambda_function" "lambda" {
  s3_bucket        = "${var.obcon_module_bucket}"
  s3_key           = "${var.obcon_module_name}/${var.obcon_module_name}_${var.obcon_module_version}_code.zip"
  function_name    = "${var.project}-${var.stage}-${var.obcon_module_name}"
  role             = "${aws_iam_role.lambda.arn}"
  handler          = "main.handler"
  runtime          = "python3.6"
}


