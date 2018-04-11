output "arn" {
  # The Amazon Resource Name (ARN) identifying your Lambda Function.
  value = "${element(concat(aws_lambda_function.schedule.*.arn, list("")), 0)}"
}

output "function_name" {
  # The Function Name identifying your Lambda Function.
  value = "${element(concat(aws_lambda_function.schedule.*.function_name, list("")), 0)}"
}

output "qualified_arn" {
  # The Amazon Resource Name (ARN) identifying your Lambda Function Version (if versioning is enabled via publish = true).
  value = "${element(concat(aws_lambda_function.schedule.*.qualified_arn, list("")), 0)}"
}

output "invoke_arn" {
  # The ARN to be used for invoking Lambda Function from API Gateway - to be used in aws_api_gateway_integration's uri
  value = "${element(concat(aws_lambda_function.schedule.*.qualified_arn, list("")), 0)}"
}

output "version" {
  # Latest published version of your Lambda Function.
  value = "${element(concat(aws_lambda_function.schedule.*.version, list("")), 0)}"
}
