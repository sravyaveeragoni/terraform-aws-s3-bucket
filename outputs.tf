output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.this.arn
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  value       = aws_dynamodb_table.this.name
}

output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table"
  value       = aws_dynamodb_table.this.arn
}

output "dynamodb_table_2_name" {
  description = "Name of the second DynamoDB table"
  value       = aws_dynamodb_table.second.name
}

output "dynamodb_table_2_arn" {
  description = "ARN of the second DynamoDB table"
  value       = aws_dynamodb_table.second.arn
}
