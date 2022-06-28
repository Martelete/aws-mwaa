########################################################################################################################
##
## Module for deployment and management of an AWS Managed Workflows Apache Airflow
##
########################################################################################################################

data "aws_caller_identity" "current" {}

locals {
  tf_account_id = data.aws_caller_identity.current.account_id
}


resource "aws_iam_role" "mwaa_iam_role" {
  name = var.name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = [
            "airflow.amazonaws.com",
            "airflow-env.amazonaws.com"
          ]
        }
        Action = "sts:AssumeRole"
      },
    ]
  })

  tags = merge(var.tags, {
    Name = var.name
  })
}

## The Policy configuration below is following "AWS Owned CMK" however this can be replaced by using "Customer Managed CMK" once we have created our "customer-managed keys".
## For more information abot the Policy below, see https://docs.aws.amazon.com/mwaa/latest/userguide/mwaa-create-role.html#mwaa-create-role-json

data "aws_iam_policy_document" "mwaa_iam_policy_document" {
  statement {
    effect = "Allow"

    actions = [
      "airflow:PublishMetrics"
    ]

    resources = [
      "arn:aws:airflow:${var.region}:${local.tf_account_id}:environment/${var.name}"
    ]
  }

  statement {
    effect = "Deny"

    actions = [
      "s3:ListAllMyBuckets"
    ]

    resources = [
      format("arn:aws:s3:::%s", var.bucket_name),
      format("arn:aws:s3:::%s/*", var.bucket_name)
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject*",
      "s3:GetBucket*",
      "s3:List*"
    ]

    resources = [
      format("arn:aws:s3:::%s", var.bucket_name),
      format("arn:aws:s3:::%s/*", var.bucket_name)
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:PutLogEvents",
      "logs:GetLogEvents",
      "logs:GetLogRecord",
      "logs:GetLogGroupFields",
      "logs:GetQueryResults",
      "logs:DescribeLogGroups"
    ]

    resources = [
      "arn:aws:logs:${var.region}:${local.tf_account_id}:log-group:airflow-${var.name}-*"
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "logs:DescribeLogGroups"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "cloudwatch:PutMetricData"
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "sqs:ChangeMessageVisibility",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "sqs:ReceiveMessage",
      "sqs:SendMessage"
    ]

    resources = [
      "arn:aws:sqs:${var.region}:*:airflow-celery-*"
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:GenerateDataKey*",
      "kms:Encrypt"
    ]

    not_resources = ["arn:aws:kms:*:${local.tf_account_id}:key/${var.kms_key_id}"]

    condition {
      test     = "StringLike"
      variable = "kms:ViaService"

      values = [
        "sqs.${var.region}.amazonaws.com",
        "s3.${var.region}.amazonaws.com"
      ]
    }
  }
}


resource "aws_iam_policy" "mwaa_iam_policy" {
  name   = var.policy_name
  path   = "/"
  policy = data.aws_iam_policy_document.mwaa_iam_policy_document.json
}


resource "aws_iam_role_policy_attachment" "mwaa_iam_role_policy_attachment" {
  role       = aws_iam_role.mwaa_iam_role.name
  policy_arn = aws_iam_policy.mwaa_iam_policy.arn
}

##
## MWAA ENVIRONMENT MODULE
##

resource "aws_mwaa_environment" "mwaa_environment" {

  name = var.name

  airflow_configuration_options = var.airflow_config_options
  airflow_version               = var.airflow_version

  source_bucket_arn         = var.source_bucket_arn
  dag_s3_path               = var.dag_s3_path
  plugins_s3_object_version = var.plugins_s3_object_version
  requirements_s3_path      = var.requirements_s3_path

  environment_class = var.environment_class
  max_workers       = var.max_workers
  min_workers       = var.min_workers

  kms_key            = var.kms_key
  execution_role_arn = aws_iam_role.mwaa_iam_role.arn

  webserver_access_mode = var.webserver_access_mode


  network_configuration {
    security_group_ids = var.security_group_ids
    subnet_ids         = var.subnet_ids
  }


  dynamic "logging_configuration" {
    for_each = length(keys(var.logging_configuration)) == 0 ? [] : [var.logging_configuration]

    content {
      dynamic "dag_processing_logs" {
        for_each = length(keys(lookup(logging_configuration.value, "dag_processing_logs", {}))) == 0 ? [] : [lookup(logging_configuration.value, "dag_processing_logs", {})]

        content {
          enabled   = lookup(dag_processing_logs.value, "enabled", null)
          log_level = lookup(dag_processing_logs.value, "log_level", null)
        }
      }

      dynamic "scheduler_logs" {
        for_each = length(keys(lookup(logging_configuration.value, "scheduler_logs", {}))) == 0 ? [] : [lookup(logging_configuration.value, "scheduler_logs", {})]

        content {
          enabled   = lookup(scheduler_logs.value, "enabled", null)
          log_level = lookup(scheduler_logs.value, "log_level", null)
        }
      }

      dynamic "task_logs" {
        for_each = length(keys(lookup(logging_configuration.value, "task_logs", {}))) == 0 ? [] : [lookup(logging_configuration.value, "task_logs", {})]

        content {
          enabled   = lookup(task_logs.value, "enabled", null)
          log_level = lookup(task_logs.value, "log_level", null)
        }
      }

      dynamic "webserver_logs" {
        for_each = length(keys(lookup(logging_configuration.value, "webserver_logs", {}))) == 0 ? [] : [lookup(logging_configuration.value, "webserver_logs", {})]

        content {
          enabled   = lookup(webserver_logs.value, "enabled", null)
          log_level = lookup(webserver_logs.value, "log_level", null)
        }
      }

      dynamic "worker_logs" {
        for_each = length(keys(lookup(logging_configuration.value, "worker_logs", {}))) == 0 ? [] : [lookup(logging_configuration.value, "worker_logs", {})]

        content {
          enabled   = lookup(worker_logs.value, "enabled", null)
          log_level = lookup(worker_logs.value, "log_level", null)
        }
      }
    }
  }

  tags = merge({ Name = var.name }, var.tags)
}