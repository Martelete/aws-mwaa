########################################################################################################################
##
## Variables
##
########################################################################################################################

##
## Terraform configuration section
##

variable "region" {
  description = "Region where main resources should be created."
  type        = string
  default     = "eu-central-1"
}

variable "tf_account_id" {
  description = "Data account to have cross access"
  type        = string
  default     = ""
}


##
## Airflow configuration section
##

variable "name" {
  description = "The name of the Apache Airflow Environment"
  type        = string
}

variable "policy_name" {
  description = "The name of the IAM policy"
  type        = string
  default     = "MWAA-Execution-Policy"
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = ""
}

variable "airflow_config_options" {
  description = "The number of tasks retries. For more information, see https://docs.aws.amazon.com/mwaa/latest/userguide/configuring-env-variables.html#configuring-env-variables-reference"
  type        = map(string)
  default     = {}
}

variable "airflow_version" {
  description = "Airflow version of your environment, will be set by default to the latest version that MWAA supports."
  type        = string
  default     = "2.0.2"
}

variable "source_bucket_arn" {
  description = "The relative path to the DAG folder on your Amazon S3 storage bucket"
  type        = string
  default     = ""
}

variable "dag_s3_path" {
  description = "The relative path to the DAG folder on your Amazon S3 storage bucket"
  type        = string
  default     = "dags/"
}

variable "environment_class" {
  description = "Environment class for the cluster. Possible options are mw1.small, mw1.medium, mw1.large. Will be set by default to mw1.small"
  type        = string
  default     = ""
}

variable "webserver_access_mode" {
  description = "Specifies whether the webserver should be accessible over the internet or via your specified VPC. Possible options: PRIVATE_ONLY (default) and PUBLIC_ONLY"
  type        = string
  default     = "PRIVATE_ONLY"
}

variable "security_group_ids" {
  description = "A Security Group associated"
  type        = list(string)
  default     = []
}

variable "subnet_ids" {
  description = "A list of VPC Subnet IDs to launch in"
  type        = list(string)
  default     = []
}

variable "kms_key" {
  description = "The Amazon Resource Name (ARN) of your KMS key that you want to use for encryption. Will be set to the ARN of the managed KMS key aws/airflow by default"
  type        = string
  default     = ""
}

variable "kms_key_id" {
  description = "The KMS key ID that you want to use for encryption. Will be set to the ARN of the managed KMS key aws/airflow by default"
  type        = string
  default     = ""
}

variable "max_workers" {
  description = "The maximum number of workers that can be automatically scaled up. Value need to be between 1 and 25. Will be 10 by default"
  type        = string
  default     = 10
}

variable "min_workers" {
  description = "The minimum number of workers that you want to run in your environment. Will be 1 by default"
  type        = string
  default     = 1
}

variable "plugins_s3_object_version" {
  description = "The requirements.txt file version you want to use."
  type        = string
  default     = ""
}

variable "requirements_s3_path" {
  description = "The relative path to the requirements.txt file on your Amazon S3 storage bucket. For example, requirements.txt. If a relative path is provided in the request, then requirements_s3_object_version is required."
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "ID of the VPC where to create security group"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Resources tag information."
  type        = map(string)
  default     = {}
}

##
## POLICIES VARIABLES
##

variable "airflow_role" {
  description = "The role name to be granted in Airflow" ### For more information about roles, see https://airflow.apache.org/docs/apache-airflow/1.10.6/security.html?highlight=ldap#default-roles
  type        = string
  default     = "Admin"
}

variable "mwaa_full_access" {
  description = "The name of the AWS IAM Policy"
  type        = string
  default     = "AmazonMWAAFullConsoleAccess"
}

variable "mwaa_webserver_access" {
  description = "The name of the AWS IAM Policy"
  type        = string
  default     = "AmazonMWAAWebServerAccess"
}

variable "mwaa_airflow_cli_access" {
  description = "The name of the AWS IAM Policy"
  type        = string
  default     = "AmazonMWAAAirflowCliAccess"
}

##
## Airflow Logging Configurations
## There are 4 types of logging configurations such as: INFO, CRITICAL, ERROR, WARNING
##
## INFO: Log info and higher-severity events
## CRITICAL: Log critical events only
## ERROR: Log error and higher-severity events
## WARNING: Log warning and higher-severity events
##

variable "logging_configuration" {
  description = "Specifies the network configuration for your Apache Airflow Environment. This includes two private subnets as well as security groups for the Airflow environment"
  type        = any
  default     = {}
}


##
## VPC ENDPOINT VARIABLES
##

## S3 ##

variable "s3_endpoint_type" {
  description = "The type of VPC Endpoint"
  type        = string
  default     = "Gateway"
}

variable "enable_s3_endpoint" {
  description = "Enable provisioning of an S3 endpoint."
  type        = bool
  default     = true
}

variable "route_table_ids" {
  description = "The list of route tables associated"
  type        = list(string)
  default     = []
}

## KMS ##

variable "enable_kms_endpoint" {
  description = "Enable provisioning of a KMS endpoint."
  type        = bool
  default     = true
}

variable "kms_endpoint_security_group_ids" {
  description = "The ID of one or more security groups to associate with the network interface for KMS endpoint."
  type        = list(string)
  default     = []
}

variable "kms_endpoint_subnet_ids" {
  description = "The ID of one or more subnets in which to create a network interface for KMS endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}

## ECR API ##

variable "enable_ecr_api_endpoint" {
  description = "Enable provisioning of an ecr api endpoint"
  type        = bool
  default     = true
}

variable "ecr_api_endpoint_security_group_ids" {
  description = "The ID of one or more security groups to associate with the network interface for ECR API endpoint."
  type        = list(string)
  default     = []
}

variable "ecr_api_endpoint_subnet_ids" {
  description = "The ID of one or more subnets in which to create a network interface for ECR api endpoint. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}

## ECR DKR ##

variable "enable_ecr_dkr_endpoint" {
  description = "Enable provisioning of an ecr api endpoint"
  type        = bool
  default     = true
}

variable "ecr_dkr_endpoint_security_group_ids" {
  description = "The ID of one or more security groups to associate with the network interface for ECR API endpoint."
  type        = list(string)
  default     = []
}

variable "ecr_dkr_endpoint_subnet_ids" {
  description = "The ID of one or more subnets in which to create a network interface for ECR api endpoint. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}

## CLOUDWATCH LOGS ##

variable "enable_logs_endpoint" {
  description = "Enable provisioning of a CloudWatch Logs endpoint"
  type        = bool
  default     = true
}

variable "logs_endpoint_security_group_ids" {
  description = "The ID of one or more security groups to associate with the network interface for CloudWatch Logs endpoint"
  type        = list(string)
  default     = []
}

variable "logs_endpoint_subnet_ids" {
  description = "The ID of one or more subnets in which to create a network interface for CloudWatch Logs endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}

## CLOUDWATCH MONITORING ##

variable "enable_monitoring_endpoint" {
  description = "Enable provisioning of a CloudWatch Monitoring endpoint."
  type        = bool
  default     = true
}

variable "monitoring_endpoint_security_group_ids" {
  description = "The ID of one or more security groups to associate with the network interface for CloudWatch Monitoring endpoint."
  type        = list(string)
  default     = []
}

variable "monitoring_endpoint_subnet_ids" {
  description = "The ID of one or more subnets in which to create a network interface for CloudWatch Monitoring endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}

## SQS ##

variable "enable_sqs_endpoint" {
  description = "Enable provisioning of an SQS endpoint."
  type        = bool
  default     = true
}

variable "sqs_endpoint_security_group_ids" {
  description = "The ID of one or more security groups to associate with the network interface for SQS endpoint."
  type        = list(string)
  default     = []
}

variable "sqs_endpoint_subnet_ids" {
  description = "The ID of one or more subnets in which to create a network interface for SQS endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}

## AIRFLOW API ##

variable "enable_airflow_api_endpoint" {
  description = "Enable provisioning of an SQS endpoint."
  type        = bool
  default     = true
}

variable "airflow_api_endpoint_security_group_ids" {
  description = "The ID of one or more security groups to associate with the network interface for SQS endpoint."
  type        = list(string)
  default     = []
}

variable "airflow_api_endpoint_subnet_ids" {
  description = "The ID of one or more subnets in which to create a network interface for SQS endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}

## AIRFLOW ENV ##

variable "enable_airflow_env_endpoint" {
  description = "Enable provisioning of an SQS endpoint."
  type        = bool
  default     = true
}

variable "airflow_env_endpoint_security_group_ids" {
  description = "The ID of one or more security groups to associate with the network interface for SQS endpoint."
  type        = list(string)
  default     = []
}

variable "airflow_env_endpoint_subnet_ids" {
  description = "The ID of one or more subnets in which to create a network interface for SQS endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}

## AIRFLOW OPS ##

variable "enable_airflow_ops_endpoint" {
  description = "Enable provisioning of an SQS endpoint."
  type        = bool
  default     = true
}

variable "airflow_ops_endpoint_security_group_ids" {
  description = "The ID of one or more security groups to associate with the network interface for SQS endpoint."
  type        = list(string)
  default     = []
}

variable "airflow_ops_endpoint_subnet_ids" {
  description = "The ID of one or more subnets in which to create a network interface for SQS endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}