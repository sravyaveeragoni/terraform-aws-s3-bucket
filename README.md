# terraform-aws-s3-bucket

Terraform project that creates a secure S3 bucket in AWS (versioning, AES-256 encryption, public access blocked).

## Usage
```bash
aws configure                       # or export AWS_PROFILE
cp terraform.tfvars.example terraform.tfvars   # set a globally unique bucket_name
terraform init
terraform plan
terraform apply
```
Destroy with `terraform destroy`.
