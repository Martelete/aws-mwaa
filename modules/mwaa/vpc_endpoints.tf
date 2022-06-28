########################################################################################################################
##
## VPC Endpoints
##
## - VPC Endpoint for S3
## - VPC Endpoint for KMS
## - VPC Endpoint for ECR API
## - VPC Endpoint for ECR DKR
## - VPC Endpoint for CloudWatch Logs
## - VPC Endpoint for CloudWatch Monitoring
## - VPC Endpoint for SQS
## - VPC Endpoint for Airflow API
## - VPC Endpoint for Airflow ENV
## - VPC Endpoint for Airflow OPS
##
########################################################################################################################

#
# VPC Endpoint for S3
#

data "aws_vpc_endpoint_service" "s3" {
  count = var.enable_s3_endpoint ? 1 : 0

  service_type = var.s3_endpoint_type
  service      = "s3"
}

resource "aws_vpc_endpoint" "s3" {
  count = var.enable_s3_endpoint ? 1 : 0

  vpc_id            = var.vpc_id
  vpc_endpoint_type = "Gateway"
  service_name      = data.aws_vpc_endpoint_service.s3[0].service_name

  tags = merge(
    {
      Name = format("vpce-s3-%s", var.region)
    },
    var.tags
  )
}

resource "aws_vpc_endpoint_route_table_association" "private_s3" {
  count = length(var.route_table_ids)

  vpc_endpoint_id = aws_vpc_endpoint.s3[0].id
  route_table_id  = element(var.route_table_ids, count.index)
}


##
## VPC Endpoint for KMS
##

data "aws_vpc_endpoint_service" "kms" {
  count = var.enable_kms_endpoint ? 1 : 0

  service = "kms"
}

resource "aws_vpc_endpoint" "kms" {
  count = var.enable_kms_endpoint ? 1 : 0

  vpc_id            = var.vpc_id
  service_name      = data.aws_vpc_endpoint_service.kms[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = var.kms_endpoint_security_group_ids
  subnet_ids          = var.kms_endpoint_subnet_ids
  private_dns_enabled = true

  tags = merge(
    {
      Name = format("vpce-kms-%s", var.region)
    },
    var.tags
  )
}


##
## VPC Endpoint for ECR API
##

data "aws_vpc_endpoint_service" "ecr_api" {
  count = var.enable_ecr_api_endpoint ? 1 : 0

  service = "ecr.api"
}

resource "aws_vpc_endpoint" "ecr_api" {
  count = var.enable_ecr_api_endpoint ? 1 : 0

  vpc_id            = var.vpc_id
  service_name      = data.aws_vpc_endpoint_service.ecr_api[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = var.ecr_api_endpoint_security_group_ids
  subnet_ids          = var.ecr_api_endpoint_subnet_ids
  private_dns_enabled = true

  tags = merge(
    {
      Name = format("vpce-ecr-api-%s", var.region)
    },
    var.tags
  )
}

##
## VPC Endpoint for ECR DKR
##

data "aws_vpc_endpoint_service" "ecr_dkr" {
  count = var.enable_ecr_dkr_endpoint ? 1 : 0

  service = "ecr.dkr"
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  count = var.enable_ecr_dkr_endpoint ? 1 : 0

  vpc_id            = var.vpc_id
  service_name      = data.aws_vpc_endpoint_service.ecr_dkr[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = var.ecr_dkr_endpoint_security_group_ids
  subnet_ids          = var.ecr_dkr_endpoint_subnet_ids
  private_dns_enabled = true

  tags = merge(
    {
      Name = format("vpce-ecr-dkr-%s", var.region)
    },
    var.tags
  )
}


##
## VPC Endpoint for CloudWatch Logs
##

data "aws_vpc_endpoint_service" "logs" {
  count = var.enable_logs_endpoint ? 1 : 0

  service = "logs"
}

resource "aws_vpc_endpoint" "logs" {
  count = var.enable_logs_endpoint ? 1 : 0

  vpc_id            = var.vpc_id
  service_name      = data.aws_vpc_endpoint_service.logs[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = var.logs_endpoint_security_group_ids
  subnet_ids          = var.logs_endpoint_subnet_ids
  private_dns_enabled = true

  tags = merge(
    {
      Name = format("vpce-logs-%s", var.region)
    },
    var.tags
  )
}

##
## VPC Endpoint for CloudWatch Monitoring
##

data "aws_vpc_endpoint_service" "monitoring" {
  count = var.enable_monitoring_endpoint ? 1 : 0

  service = "monitoring"
}

resource "aws_vpc_endpoint" "monitoring" {
  count = var.enable_monitoring_endpoint ? 1 : 0

  vpc_id            = var.vpc_id
  service_name      = data.aws_vpc_endpoint_service.monitoring[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = var.monitoring_endpoint_security_group_ids
  subnet_ids          = var.monitoring_endpoint_subnet_ids
  private_dns_enabled = true

  tags = merge(
    {
      Name = format("vpce-monitoring-%s", var.region)
    },
    var.tags
  )
}

##
## VPC Endpoint for SQS
##

data "aws_vpc_endpoint_service" "sqs" {
  count = var.enable_sqs_endpoint ? 1 : 0

  service = "sqs"
}

resource "aws_vpc_endpoint" "sqs" {
  count = var.enable_sqs_endpoint ? 1 : 0

  vpc_id            = var.vpc_id
  service_name      = data.aws_vpc_endpoint_service.sqs[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = var.sqs_endpoint_security_group_ids
  subnet_ids          = var.sqs_endpoint_subnet_ids
  private_dns_enabled = true

  tags = merge(
    {
      Name = format("vpce-sqs-%s", var.region)
    },
    var.tags
  )
}


##
## AIRFLOW VPC ENDPOINTS
##


##
## VPC Endpoint for Airflow API
##

data "aws_vpc_endpoint_service" "airflow_api" {
  count = var.enable_airflow_api_endpoint ? 1 : 0

  service = "airflow.api"
}

resource "aws_vpc_endpoint" "airflow_api" {
  count = var.enable_airflow_api_endpoint ? 1 : 0

  vpc_id            = var.vpc_id
  service_name      = data.aws_vpc_endpoint_service.airflow_api[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = var.airflow_api_endpoint_security_group_ids
  subnet_ids          = var.airflow_api_endpoint_subnet_ids
  private_dns_enabled = true

  tags = merge(
    {
      Name = format("vpce-airflow-api-%s", var.region)
    },
    var.tags
  )
}

##
## VPC Endpoint for Airflow ENV
##

data "aws_vpc_endpoint_service" "airflow_env" {
  count = var.enable_airflow_env_endpoint ? 1 : 0

  service = "airflow.env"
}

resource "aws_vpc_endpoint" "airflow_env" {
  count = var.enable_airflow_env_endpoint ? 1 : 0

  vpc_id            = var.vpc_id
  service_name      = data.aws_vpc_endpoint_service.airflow_env[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = var.airflow_env_endpoint_security_group_ids
  subnet_ids          = var.airflow_env_endpoint_subnet_ids
  private_dns_enabled = true

  tags = merge(
    {
      Name = format("vpce-airflow-env-%s", var.region)
    },
    var.tags
  )
}

##
## VPC Endpoint for Airflow OPS
##

data "aws_vpc_endpoint_service" "airflow_ops" {
  count = var.enable_airflow_ops_endpoint ? 1 : 0

  service = "airflow.ops"
}

resource "aws_vpc_endpoint" "airflow_ops" {
  count = var.enable_airflow_ops_endpoint ? 1 : 0

  vpc_id            = var.vpc_id
  service_name      = data.aws_vpc_endpoint_service.airflow_ops[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = var.airflow_ops_endpoint_security_group_ids
  subnet_ids          = var.airflow_ops_endpoint_subnet_ids
  private_dns_enabled = true

  tags = merge(
    {
      Name = format("vpce-airflow-ops-%s", var.region)
    },
    var.tags
  )
}