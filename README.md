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

## DynamoDB table
`dynamodb.tf` also creates a DynamoDB table (on-demand billing, point-in-time recovery and encryption on). Override `dynamodb_table_name`, `dynamodb_hash_key`, `dynamodb_range_key` or `dynamodb_billing_mode` in `terraform.tfvars`.

## CI/CD (GitHub Actions)
`.github/workflows/terraform.yml`:
- **Pull request to `main`**: `fmt`, `init`, `validate`, `plan` (nothing is deployed).
- **Merge of a PR into `main`** (`deploy-dynamodb.yml`): `terraform apply -target=aws_dynamodb_table.this`.

One-time setup:
1. `bash scripts/bootstrap.sh` (creates remote state bucket, lock table, GitHub OIDC role).
2. `terraform init -migrate-state` to move local state to S3.
3. In GitHub: secret `AWS_ROLE_ARN` = role ARN printed by the script; variable `BUCKET_NAME` = your bucket name.
4. Protect `main` (Settings > Branches) so changes only land through a pull request.
