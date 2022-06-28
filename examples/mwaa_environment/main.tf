#
# Locals
#

locals {
  team        = ""
  mwaa_name   = format("mwaa-%s", local.team)
  bucket_name = ""
  bucket_arn  = format("arn:aws:s3:::%s", local.bucket_name)

  subnet_ids      = ["", ""]
  route_table_ids = ["", ""]
  
  tags = {
    Name        = "example"
    Environment = "production"
  }
}

#
# Variables
#

variable "region" {
  description = "AWS Region to deploy resources."
  type        = string
  default     = "eu-central-1"
}

#
# Data Sources
#

data "aws_caller_identity" "current" {}

data "aws_vpc" "vpc_id" {
  filter {
    name   = "tag:Name"
    values = ["<your_vpc_name>"]
  }
}


##
## MWAA ENVIRONMENT
##

module "mwaa" {
  // source = "git@github.com:Martelete/aws-mwaa.git//modules/mwaa"
  source = "../../modules/mwaa"

  providers = {
    aws = aws
  }

  name = local.mwaa_name

  source_bucket_arn = local.bucket_arn
  environment_class = "mw1.small"
  max_workers       = 3
  min_workers       = 1

  # The default value is set to "PRIVATE_ONLY" however it needs to setup VPN access as the Airflow IP provided is private.
  # For the main accounts, it might be required Transit Gateway which will allow to access from the VPN.
  # For testing purposes we are using "PUBLIC_ONLY"
  webserver_access_mode = "PUBLIC_ONLY"

  ## Variables that is defined on the module but not input values and expect user to add
  bucket_name = local.bucket_name

  ## Network Configuration
  security_group_ids = [aws_security_group.mwaa_sg.id]
  subnet_ids         = local.subnet_ids


  logging_configuration = {
    dag_processing_logs = {
      enabled   = true
      log_level = "WARNING"
    }

    scheduler_logs = {
      enabled   = true
      log_level = "ERROR"
    }

    task_logs = {
      enabled   = true
      log_level = "CRITICAL"
    }

    webserver_logs = {
      enabled   = true
      log_level = "INFO"
    }

    worker_logs = {
      enabled   = true
      log_level = "WARNING"
    }
  }

  tags = local.tags


  # ##
  # ## VPC ENDPOINT
  # ##

  vpc_id = data.aws_vpc.vpc_id.id

  enable_s3_endpoint = true
  route_table_ids    = local.route_table_ids

  enable_kms_endpoint             = true
  kms_endpoint_security_group_ids = aws_security_group.mwaa_sg.*.id
  kms_endpoint_subnet_ids         = local.subnet_ids

  enable_ecr_api_endpoint             = true
  ecr_api_endpoint_security_group_ids = aws_security_group.mwaa_sg.*.id
  ecr_api_endpoint_subnet_ids         = local.subnet_ids

  enable_ecr_dkr_endpoint             = true
  ecr_dkr_endpoint_security_group_ids = aws_security_group.mwaa_sg.*.id
  ecr_dkr_endpoint_subnet_ids         = local.subnet_ids

  enable_logs_endpoint             = true
  logs_endpoint_security_group_ids = aws_security_group.mwaa_sg.*.id
  logs_endpoint_subnet_ids         = local.subnet_ids

  enable_monitoring_endpoint             = true
  monitoring_endpoint_security_group_ids = aws_security_group.mwaa_sg.*.id
  monitoring_endpoint_subnet_ids         = local.subnet_ids

  enable_sqs_endpoint             = true
  sqs_endpoint_security_group_ids = aws_security_group.mwaa_sg.*.id
  sqs_endpoint_subnet_ids         = local.subnet_ids

  enable_airflow_api_endpoint             = true
  airflow_api_endpoint_security_group_ids = aws_security_group.mwaa_sg.*.id
  airflow_api_endpoint_subnet_ids         = local.subnet_ids

  enable_airflow_env_endpoint             = true
  airflow_env_endpoint_security_group_ids = aws_security_group.mwaa_sg.*.id
  airflow_env_endpoint_subnet_ids         = local.subnet_ids

  enable_airflow_ops_endpoint             = true
  airflow_ops_endpoint_security_group_ids = aws_security_group.mwaa_sg.*.id
  airflow_ops_endpoint_subnet_ids         = local.subnet_ids
}

##
## AIRFLOW SECURITY GROUP
##

## For the testing purposes we are open it ingress to all traffic. 

resource "aws_security_group" "mwaa_sg" {
  name        = "mwaa-sg-${var.region}"
  description = "Security Group for MWAA Environment"
  vpc_id      = data.aws_vpc.vpc_id.id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = -1
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      Name = "mwaa-sg-${var.region}"
    },
    local.tags
  )
}