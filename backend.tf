# Remote state so GitHub Actions and your laptop share the same state.
# Create these resources once with scripts/bootstrap.sh.
terraform {
  backend "s3" {
    bucket         = "sravya-tfstate-144582450224"
    key            = "terraform-aws-s3-bucket/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}
