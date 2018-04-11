module "label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.2.1"
  namespace  = "${var.namespace}"
  stage      = "${var.environment}"
  name       = "${var.name}-schedule"
  tags       = "${var.tags}"
}

resource "aws_cloudwatch_event_rule" "main" {
  name                = "${module.label.id}"
  description         = "Call first endpoints every ${var.schedule_rate} to keep them warm"

  schedule_expression = "rate(${var.schedule_rate})"
  is_enabled          = "${var.schedule_is_enabled}"
}

resource "aws_cloudwatch_event_target" "execute" {
  rule                = "${aws_cloudwatch_event_rule.main.name}"

  arn                 = "${aws_lambda_function.schedule.arn}"
}

resource "aws_lambda_permission" "schedule" {
  statement_id        = "AllowExecutionFromCloudwatchRules"
  action              = "lambda:InvokeFunction"

  function_name       = "${aws_lambda_function.schedule.function_name}"
  principal           = "events.amazonaws.com"

  source_arn          = "${aws_cloudwatch_event_rule.main.arn}"
}

data "aws_iam_policy_document" "logs" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams"
    ]

    resources = [
      "arn:aws:logs:*:*:*"
    ]
  }
}

resource "aws_iam_role_policy" "logs_policy" {
  name = "${module.label.id}-logs"
  role = "${aws_iam_role.role.id}"

  policy = "${data.aws_iam_policy_document.logs.json}"
}

resource "aws_iam_role_policy_attachment" "custom" {
  # count                 = "${length(var.execution_policies)}"
  count                 = "${var.execution_policies_count}"

  role                  = "${aws_iam_role.role.name}"

  policy_arn            = "${element(var.execution_policies, count.index)}"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    sid = ""

    actions = [
      "sts:AssumeRole"
    ]

    principals = {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "role" {
  name = "${module.label.id}"

  assume_role_policy = "${data.aws_iam_policy_document.assume_role.json}"
}

resource "aws_lambda_function" "schedule" {
  filename            = "${var.filename}"

  function_name       = "${module.label.id}"
  role                = "${aws_iam_role.role.arn}"

  handler             = "${var.handler}"
  # nodejs8.10
  runtime             = "${var.runtime}"
  source_code_hash    = "${base64sha256(file(var.filename))}"
  memory_size         = "${var.memory_size}"
  timeout             = "${var.timeout}"

  tags                = "${module.label.tags}"

  environment         = {
    variables           = "${merge(module.label.tags, var.environment_variables)}"
  }
}
