variable "aws_region" {
  description = "AWS region to create the bucket in"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Globally unique S3 bucket name (lowercase, 3-63 chars)"
  type        = string
}

variable "versioning_enabled" {
  description = "Enable object versioning"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags applied to the bucket"
  type        = map(string)
  default     = {}
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  type        = string
  default     = "sravya-demo-table"
}

variable "dynamodb_hash_key" {
  description = "Partition key attribute name (type String)"
  type        = string
  default     = "id"
}

variable "dynamodb_range_key" {
  description = "Optional sort key attribute name (type String)"
  type        = string
  default     = null
}

variable "dynamodb_billing_mode" {
  description = "PAY_PER_REQUEST or PROVISIONED"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "dynamodb_read_capacity" {
  description = "Read capacity units (only when PROVISIONED)"
  type        = number
  default     = 5
}

variable "dynamodb_write_capacity" {
  description = "Write capacity units (only when PROVISIONED)"
  type        = number
  default     = 5
}
