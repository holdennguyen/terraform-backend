#-----------------------------------------------------------------------------
# IAM Policy for Executing Terraform with Remote States
# See below for permissions necessary to run Terraform
# https://developer.hashicorp.com/terraform/language/settings/backends/s3#example-configuration
#-----------------------------------------------------------------------------

resource "aws_iam_policy" "terraform" {
  count = var.terraform_iam_policy_create ? 1 : 0

  name_prefix = var.override_terraform_iam_policy_name ? null : var.terraform_iam_policy_name_prefix
  name        = var.override_terraform_iam_policy_name ? var.terraform_iam_policy_name : null
  policy      = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:ListBucket",
            "Resource": "${aws_s3_bucket.state.arn}"
        },
        {
            "Effect": "Allow",
            "Action": ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"],
            "Resource": "${aws_s3_bucket.state.arn}/*"
        },
        {
            "Effect": "Allow",
            "Action": ["dynamodb:DescribeTable","dynamodb:GetItem","dynamodb:PutItem","dynamodb:DeleteItem"],
            "Resource": "${aws_dynamodb_table.lock.arn}"
        },
        {
            "Effect": "Allow",
            "Action": ["kms:Encrypt","kms:Decrypt","kms:DescribeKey","kms:GenerateDataKey"],
            "Resource": "${aws_kms_key.this.arn}"
        }
    ]
}
    POLICY

  tags = var.tags
}