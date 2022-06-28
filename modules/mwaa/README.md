# AWS Managed Workflows Apache Airflow


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.29 |
| aws | >= 3.45 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.45 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_caller_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) |
| [aws_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) |
| [aws_iam_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) |
| [aws_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) |
| [aws_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) |
| [aws_mwaa_environment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/mwaa_environment) |
| [aws_vpc_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) |
| [aws_vpc_endpoint_route_table_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_route_table_association) |
| [aws_vpc_endpoint_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_endpoint_service) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| airflow_api_endpoint_security_group_ids | The ID of one or more security groups to associate with the network interface for SQS endpoint. | `list(string)` | `[]` | no |
| airflow_api_endpoint_subnet_ids | The ID of one or more subnets in which to create a network interface for SQS endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used. | `list(string)` | `[]` | no |
| airflow_config_options | The number of tasks retries. For more information, see https://docs.aws.amazon.com/mwaa/latest/userguide/configuring-env-variables.html#configuring-env-variables-reference | `map(string)` | `{}` | no |
| airflow_env_endpoint_security_group_ids | The ID of one or more security groups to associate with the network interface for SQS endpoint. | `list(string)` | `[]` | no |
| airflow_env_endpoint_subnet_ids | The ID of one or more subnets in which to create a network interface for SQS endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used. | `list(string)` | `[]` | no |
| airflow_ops_endpoint_security_group_ids | The ID of one or more security groups to associate with the network interface for SQS endpoint. | `list(string)` | `[]` | no |
| airflow_ops_endpoint_subnet_ids | The ID of one or more subnets in which to create a network interface for SQS endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used. | `list(string)` | `[]` | no |
| airflow_role | The role name to be granted in Airflow | `string` | `"Admin"` | no |
| airflow_version | Airflow version of your environment, will be set by default to the latest version that MWAA supports. | `string` | `"2.0.2"` | no |
| bucket_name | The name of the S3 bucket | `string` | `""` | no |
| dag_s3_path | The relative path to the DAG folder on your Amazon S3 storage bucket | `string` | `"dags/"` | no |
| ecr_api_endpoint_security_group_ids | The ID of one or more security groups to associate with the network interface for ECR API endpoint. | `list(string)` | `[]` | no |
| ecr_api_endpoint_subnet_ids | The ID of one or more subnets in which to create a network interface for ECR api endpoint. If omitted, private subnets will be used. | `list(string)` | `[]` | no |
| ecr_dkr_endpoint_security_group_ids | The ID of one or more security groups to associate with the network interface for ECR API endpoint. | `list(string)` | `[]` | no |
| ecr_dkr_endpoint_subnet_ids | The ID of one or more subnets in which to create a network interface for ECR api endpoint. If omitted, private subnets will be used. | `list(string)` | `[]` | no |
| enable_airflow_api_endpoint | Enable provisioning of an SQS endpoint. | `bool` | `true` | no |
| enable_airflow_env_endpoint | Enable provisioning of an SQS endpoint. | `bool` | `true` | no |
| enable_airflow_ops_endpoint | Enable provisioning of an SQS endpoint. | `bool` | `true` | no |
| enable_ecr_api_endpoint | Enable provisioning of an ecr api endpoint | `bool` | `true` | no |
| enable_ecr_dkr_endpoint | Enable provisioning of an ecr api endpoint | `bool` | `true` | no |
| enable_kms_endpoint | Enable provisioning of a KMS endpoint. | `bool` | `true` | no |
| enable_logs_endpoint | Enable provisioning of a CloudWatch Logs endpoint | `bool` | `true` | no |
| enable_monitoring_endpoint | Enable provisioning of a CloudWatch Monitoring endpoint. | `bool` | `true` | no |
| enable_s3_endpoint | Enable provisioning of an S3 endpoint. | `bool` | `true` | no |
| enable_sqs_endpoint | Enable provisioning of an SQS endpoint. | `bool` | `true` | no |
| environment_class | Environment class for the cluster. Possible options are mw1.small, mw1.medium, mw1.large. Will be set by default to mw1.small | `string` | `""` | no |
| kms_endpoint_security_group_ids | The ID of one or more security groups to associate with the network interface for KMS endpoint. | `list(string)` | `[]` | no |
| kms_endpoint_subnet_ids | The ID of one or more subnets in which to create a network interface for KMS endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used. | `list(string)` | `[]` | no |
| kms_key | The Amazon Resource Name (ARN) of your KMS key that you want to use for encryption. Will be set to the ARN of the managed KMS key aws/airflow by default | `string` | `""` | no |
| kms_key_id | The KMS key ID that you want to use for encryption. Will be set to the ARN of the managed KMS key aws/airflow by default | `string` | `""` | no |
| logging_configuration | Specifies the network configuration for your Apache Airflow Environment. This includes two private subnets as well as security groups for the Airflow environment | `any` | `{}` | no |
| logs_endpoint_security_group_ids | The ID of one or more security groups to associate with the network interface for CloudWatch Logs endpoint | `list(string)` | `[]` | no |
| logs_endpoint_subnet_ids | The ID of one or more subnets in which to create a network interface for CloudWatch Logs endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used. | `list(string)` | `[]` | no |
| max_workers | The maximum number of workers that can be automatically scaled up. Value need to be between 1 and 25. Will be 10 by default | `string` | `10` | no |
| min_workers | The minimum number of workers that you want to run in your environment. Will be 1 by default | `string` | `1` | no |
| monitoring_endpoint_security_group_ids | The ID of one or more security groups to associate with the network interface for CloudWatch Monitoring endpoint. | `list(string)` | `[]` | no |
| monitoring_endpoint_subnet_ids | The ID of one or more subnets in which to create a network interface for CloudWatch Monitoring endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used. | `list(string)` | `[]` | no |
| mwaa_airflow_cli_access | The name of the AWS IAM Policy | `string` | `"AmazonMWAAAirflowCliAccess"` | no |
| mwaa_full_access | The name of the AWS IAM Policy | `string` | `"AmazonMWAAFullConsoleAccess"` | no |
| mwaa_webserver_access | The name of the AWS IAM Policy | `string` | `"AmazonMWAAWebServerAccess"` | no |
| name | The name of the Apache Airflow Environment | `string` | n/a | yes |
| plugins_s3_object_version | The requirements.txt file version you want to use. | `string` | `""` | no |
| policy_name | The name of the IAM policy | `string` | `"MWAA-Execution-Policy"` | no |
| region | Region where main resources should be created. | `string` | `"eu-central-1"` | no |
| requirements_s3_path | The relative path to the requirements.txt file on your Amazon S3 storage bucket. For example, requirements.txt. If a relative path is provided in the request, then requirements_s3_object_version is required. | `string` | `""` | no |
| route_table_ids | The list of route tables associated | `list(string)` | `[]` | no |
| s3_endpoint_type | The type of VPC Endpoint | `string` | `"Gateway"` | no |
| security_group_ids | A Security Group associated | `list(string)` | `[]` | no |
| source_bucket_arn | The relative path to the DAG folder on your Amazon S3 storage bucket | `string` | `""` | no |
| sqs_endpoint_security_group_ids | The ID of one or more security groups to associate with the network interface for SQS endpoint. | `list(string)` | `[]` | no |
| sqs_endpoint_subnet_ids | The ID of one or more subnets in which to create a network interface for SQS endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used. | `list(string)` | `[]` | no |
| subnet_ids | A list of VPC Subnet IDs to launch in | `list(string)` | `[]` | no |
| tags | Resources tag information. | `map(string)` | `{}` | no |
| tf_account_id | Data account to have cross access | `string` | `""` | no |
| vpc_id | ID of the VPC where to create security group | `string` | `""` | no |
| webserver_access_mode | Specifies whether the webserver should be accessible over the internet or via your specified VPC. Possible options: PRIVATE_ONLY (default) and PUBLIC_ONLY | `string` | `"PRIVATE_ONLY"` | no |

## Outputs

| Name | Description |
|------|-------------|
| mwaa_arn | The ARN of the MWAA Environment |
| service_role_arn | The Service Role ARN of the Amazon MWAA Environment |
| webserver_url | The webserver URL of the MWAA Environment |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
