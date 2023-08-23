variable "region" {
  description = "The AWS region in which resources are set up."
  type        = string
}

variable "replica_region" {
  description = "The AWS region to which the state bucket is replicated."
  type        = string
}

variable "s3_bucket_name" {
  description = "The S3 bucket name"
  type        = string
}

variable "s3_bucket_name_replica" {
  description = "The S3 bucket replica name"
  type        = string
}