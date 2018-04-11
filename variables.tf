variable "namespace" {
  type        = "string"
  description = "Namespace for the application"
  default     = "mm"
}

variable "environment" {
  type        = "string"
  description = "Environment (Stage) for the application"
  default     = "test"
}

variable "name" {
  type        = "string"
  description = "Name for the application"
  default     = "coldstart-warmup"
}

variable "tags" {
  type = "map"
  description = "Tags"
  default = {}
}

variable "schedule_rate" {
  type = "string"
  description = "The rate for the schedule"
  default = "15 minutes"
}

variable "schedule_is_enabled" {
  type = "string"
  description = "Schedule Rule is enabled (true/false)"
  default = "true"
}

variable "filename" {
  type = "string"
  description = "The path to the function's deployment package within the local filesystem."
}

variable "handler" {
  type = "string"
  description = "The function entrypoint in your code."
}

variable "runtime" {
  type = "string"
  description = "The runtime for your code"
  default = "nodejs8.10"
}

variable "memory_size" {
  type = "string"
  description = "Amount of memory in MB your Lambda Function can use at runtime. Defaults to 128."
  default = "128"
}

variable "timeout" {
  type = "string"
  description = "The amount of time your Lambda Function has to run in seconds."
  default = "60"
}

variable "environment_variables" {
  type = "map"
  description = "A map that defines environment variables for the Lambda function."
  default = {}
}

variable "execution_policies_count" {
  type = "string"
  description = "Workaround for list of resources count"
  default = "0"
}

variable "execution_policies" {
  type = "list"
  description = "The list of ARNs of the policies you want to apply to the Lambda execution role."
  default = []
}
