#!/usr/bin/env bash
# One-time AWS setup for the CI/CD pipeline. Run locally with admin credentials.
set -euo pipefail

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REGION=us-east-1
REPO="sravyaveeragoni/terraform-aws-s3-bucket"
STATE_BUCKET="sravya-tfstate-${ACCOUNT_ID}"
LOCK_TABLE="terraform-state-locks"
ROLE_NAME="github-actions-terraform"

# 1. Remote state bucket + lock table
aws s3api create-bucket --bucket "$STATE_BUCKET" --region "$REGION"
aws s3api put-bucket-versioning --bucket "$STATE_BUCKET" --versioning-configuration Status=Enabled
aws s3api put-bucket-encryption --bucket "$STATE_BUCKET" \
  --server-side-encryption-configuration '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'
aws s3api put-public-access-block --bucket "$STATE_BUCKET" \
  --public-access-block-configuration BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true
aws dynamodb create-table --table-name "$LOCK_TABLE" \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST --region "$REGION"

# 2. GitHub OIDC provider (skip if it already exists in the account)
aws iam create-open-id-connect-provider \
  --url https://token.actions.githubusercontent.com \
  --client-id-list sts.amazonaws.com \
  --thumbprint-list 6938fd4d98bab03faadb97b34396831e3780aea1 || true

# 3. IAM role GitHub Actions assumes (only this repo: PRs and main)
cat > trust.json <<JSON
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": {"Federated": "arn:aws:iam::${ACCOUNT_ID}:oidc-provider/token.actions.githubusercontent.com"},
    "Action": "sts:AssumeRoleWithWebIdentity",
    "Condition": {
      "StringEquals": {"token.actions.githubusercontent.com:aud": "sts.amazonaws.com"},
      "StringLike": {"token.actions.githubusercontent.com:sub": [
        "repo:${REPO}:ref:refs/heads/main",
        "repo:${REPO}:pull_request"
      ]}
    }
  }]
}
JSON
aws iam create-role --role-name "$ROLE_NAME" --assume-role-policy-document file://trust.json

cat > policy.json <<JSON
{
  "Version": "2012-10-17",
  "Statement": [{"Effect": "Allow", "Action": ["s3:*", "dynamodb:*"], "Resource": "*"}]
}
JSON
aws iam put-role-policy --role-name "$ROLE_NAME" --policy-name terraform-s3-dynamodb \
  --policy-document file://policy.json

rm -f trust.json policy.json
echo "Role ARN: arn:aws:iam::${ACCOUNT_ID}:role/${ROLE_NAME}"
echo "Add it as GitHub secret AWS_ROLE_ARN, and repo variable BUCKET_NAME."
