# Terraform Backend Remote State on AWS

#### Reference: [Terraform Module Registry](https://registry.terraform.io/modules/nozaq/remote-state-s3-backend/aws) v1.5.0

A terraform module to set up [remote state management](https://www.terraform.io/docs/state/remote.html) with [S3 backend](https://www.terraform.io/docs/backends/types/s3.html) for your account. It creates an encrypted S3 bucket to store state files and a DynamoDB table for state locking and consistency checking.
Resources are defined following best practices as described in [the official document](https://www.terraform.io/docs/backends/types/s3.html#multi-account-aws-architecture) and [ozbillwang/terraform-best-practices](https://github.com/ozbillwang/terraform-best-practices).

## Features

- Create a S3 bucket to store remote state files.
- Encrypt state files with KMS.
- Enable bucket replication and object versioning to prevent accidental data loss.
- Automatically transit non-current versions in S3 buckets to AWS S3 Glacier to optimize the storage cost.
- Optionally you can set to expire aged non-current versions(disabled by default).
- Optionally you can set fixed S3 bucket name to be user friendly(false by default).
- Create a DynamoDB table for state locking, encryption is optional.
- Optionally create an IAM policy to allow permissions which Terraform needs.

## Usage

Please specify your preference in the `provisioning.tfvars` file.

```hcl
region                 = "REGION_OF_THE_STATE_BUCKET"
replica_region         = "REGION_OF_THE_STATE_REPLICA_BUCKET"
s3_bucket_name         = "THE_NAME_OF_THE_STATE_BUCKET"
s3_bucket_name_replica = "THE_NAME_OF_THE_STATE_REPLICA_BUCKET"
```

Note that you need to provide two regions, one for the main state bucket and the other for the bucket to which the main state bucket is replicated to. Two providers must point to different AWS regions.

Execute the following Terraform commands to establish the backend. Remember to rerun 'terraform init' after adjusting the module configuration.

```shell
terraform init
terraform plan -var-file="provisioning.tfvars"
terraform apply -var-file="provisioning.tfvars"
```

Once resources are created, you can configure your terraform files to use the S3 backend as follows.

```hcl
terraform {
  backend "s3" {
    bucket         = "THE_NAME_OF_THE_STATE_BUCKET"
    key            = "THE_CONFIG_PATH/terraform.tfstate"
    region         = "REGION_OF_THE_STATE_BUCKET"
    encrypt        = true
    kms_key_id     = "THE_ID_OF_THE_KMS_KEY"
    dynamodb_table = "THE_ID_OF_THE_DYNAMODB_TABLE"
  }
}
```

`THE_NAME_OF_THE_STATE_BUCKET`, `THE_ID_OF_THE_DYNAMODB_TABLE` and `THE_ID_OF_THE_KMS_KEY` can be replaced by `state_bucket.bucket`, `dynamodb_table.id` and `kms_key.id` in outputs from this module respectively. `THE_CONFIG_PATH` is your preferred path on Amazon S3 that you can choose for your terraform project.

See [the official document](https://www.terraform.io/docs/backends/types/s3.html#example-configuration) for more detail.

## Compatibility

- This config requires [Terraform Provider for AWS](https://github.com/terraform-providers/terraform-provider-aws) v5.0 or later.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5 |
| <a name="provider_aws.replica"></a> [aws.replica](#provider\_aws.replica) | >= 5 |

## Outputs

```shell
dynamodb_table = "THE_ID_OF_THE_DYNAMODB_TABLE"
kms_key = "THE_ID_OF_THE_KMS_KEY"
state_bucket = "THE_NAME_OF_THE_STATE_BUCKET"
```