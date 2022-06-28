########################################################################################################################
##
## MWAA Policies for user group
##
########################################################################################################################

# The idea of this policy is to create a IAM User Groups to allow developers to manage MWAA once they login to Airflow UI indenpendently.
# For information about the permissions to be granted, see https://docs.aws.amazon.com/mwaa/latest/userguide/quick-start.html#quick-start-create-group
# For more information about the IAM Policies, see https://docs.aws.amazon.com/mwaa/latest/userguide/access-policies.html
#

##
## AmazonMWAAFullConsoleAccess
##

data "aws_iam_policy_document" "mwaa_full_access" {
  statement {
    effect = "Allow"

    actions = [
      "airflow:*",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "iam:ListRoles",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "iam:CreatePolicy",
    ]

    resources = [
      "arn:aws:iam::${local.tf_account_id}:policy/service-role/MWAA-Execution-Policy*"
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "iam:CreateServiceLinkedRole",
    ]

    resources = [
      "arn:aws:iam::*:role/aws-service-role/airflow.amazonaws.com/AWSServiceRoleForAmazonMWAA"
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:GetBucketLocation",
      "s3:ListAllMyBuckets",
      "s3:ListBucket",
      "s3:ListBucketVersions",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:CreateBucket",
      "s3:PutObject",
      "s3:GetEncryptionConfiguration",
    ]

    resources = [
      "arn:aws:s3:::*"
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeVpcs",
      "ec2:DescribeRouteTables",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CreateSecurityGroup",
    ]

    resources = [
      "arn:aws:ec2:*:*:security-group/airflow-security-group-*"
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "kms:ListAliases",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "kms:DescribeKey",
      "kms:ListGrants",
      "kms:CreateGrant",
      "kms:RevokeGrant",
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:GenerateDataKey*",
      "kms:ReEncrypt*",
    ]

    resources = [
      "arn:aws:kms:*:${local.tf_account_id}:key/${var.kms_key_id}"
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "iam:PassRole",
    ]

    resources = ["*"]

    condition {
      test     = "StringLike"
      variable = "iam:PassedToService"
      values   = ["airflow.amazonaws.com"]
    }
  }

  statement {
    effect = "Allow"

    actions = [
      "iam:AttachRolePolicy",
      "iam:CreateRole",
    ]

    resources = [
      "arn:aws:iam::${local.tf_account_id}:role/service-role/AmazonMWAA*"
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:GetEncryptionConfiguration",
    ]

    resources = [
      "arn:aws:s3:::*"
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "ec2:CreateVpcEndpoint",
    ]

    resources = [
      "arn:aws:ec2:*:*:vpc-endpoint/*",
      "arn:aws:ec2:*:*:vpc/*",
      "arn:aws:ec2:*:*:subnet/*",
      "arn:aws:ec2:*:*:security-group/*"
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "ec2:CreateNetworkInterface",
    ]

    resources = [
      "arn:aws:ec2:*:*:subnet/*",
      "arn:aws:ec2:*:*:network-interface/*"
    ]
  }
}


##
## AmazonMWAAWebServerAccess
##

data "aws_iam_policy_document" "mwaa_webserver_access" {
  statement {
    effect = "Allow"

    actions = [
      "airflow:CreateWebLoginToken",
    ]

    resources = [
      "arn:aws:airflow:${var.region}:${local.tf_account_id}:role/${var.name}/${var.airflow_role}"
    ]
  }
}


##
## AmazonMWAAAirflowCliAccess
##

data "aws_iam_policy_document" "mwaa_airflow_cli_access" {
  statement {
    effect = "Allow"

    actions = [
      "airflow:CreateCliToken",
    ]

    resources = ["*"]
  }
}


##
## IAM POLICIES
##

resource "aws_iam_policy" "mwaa_full_access_policy" {
  name   = var.mwaa_full_access
  policy = data.aws_iam_policy_document.mwaa_full_access.json
}

resource "aws_iam_policy" "mwaa_webserver_policy" {
  name   = var.mwaa_webserver_access
  policy = data.aws_iam_policy_document.mwaa_webserver_access.json
}

resource "aws_iam_policy" "mwaa_airflow_cli_access_policy" {
  name   = var.mwaa_airflow_cli_access
  policy = data.aws_iam_policy_document.mwaa_airflow_cli_access.json
}