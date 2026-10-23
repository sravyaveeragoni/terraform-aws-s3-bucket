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
