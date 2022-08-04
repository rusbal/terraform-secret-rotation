variable "function_name" {
  description = "Unique name for your Lambda Function"
  type        = string
}

variable "region" {
  description = "AWS Region"
  type        = string
}

variable "account_id" {
  description = "AWS Account ID"
  type        = number
}
