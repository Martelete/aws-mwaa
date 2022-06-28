# devops-tf-aws-mwaa

## Description

Terraform module for AWS Managed Workflows Apache Airflow

## Requirements

- [terraform](https://releases.hashicorp.com/terraform/) 0.12+

Following software should be available to develop module:

- [terraform-docs](https://github.com/segmentio/terraform-docs/releases) 0.8+
- [pre-commit](https://pre-commit.com/#install)
- [pre-commit-terraform hooks](https://github.com/antonbabenko/pre-commit-terraform)
- [tflint](https://github.com/terraform-linters/tflint)
- [tfsec](https://github.com/liamg/tfsec)


## Modules
Module supports a single MWAA Environment:

* [Single Environment](modules/mwaa)

## Usage examples

For more usage examples see submodules documentations and the [examples](examples/mwaa_environment)

## Usage

To use a module in Terraform configuration head for original [documentation](https://www.terraform.io/docs/modules/sources.html).

Cheat sheet:

- create a `module` resource and set its `source` field to the Git URL of Terraform module repository.
Good practice it to set the `ref` parameter so we're fixed to a specific version of repo, as the `master` branch could
change without backward compatibility).

Example:

```hcl
module "mwaa" {
  source    = "git@github.com:Martelete/aws-mwaa.git//modules/mwaa?ref=main"

  providers = {
    aws = aws
  }

  name                  = "mwaa-example"
  source_bucket_arn     = "arn:aws:s3:::my-bucket-example"
  environment_class     = "mw1.small"
  max_workers           = 3
  min_workers           = 1
  webserver_access_mode = "PUBLIC_ONLY"
  bucket_name           = "my-bucket-example"

  # Network configuration
  security_group_ids    = ["sg-12345678"]
  subnet_ids            = ["subnet-abcde12345"]

  logging_configuration = {
    dag_processing_logs = {
      enabled   = true
      log_level = "INFO"
    }

    scheduler_logs = {
      enabled   = true
      log_level = "INFO"
    }

    task_logs = {
      enabled   = true
      log_level = "INFO"
    }

    webserver_logs = {
      enabled   = true
      log_level = "INFO"
    }

    worker_logs = {
      enabled   = true
      log_level = "INFO"
    }
  }

  tags = {
      managed_by    = "terraform"
      Environment   = "dev"
      description   = "AWS MWAA"
  }
}
```

### Notes

- `webserver_access_mode` for the sake of this demo we are granting **PUBLIC** access as it will create a public IP address to access Airflow UI. However, for the main environments (dev, tst, ppd prd) we **MUST** use `PRIVATE_ONLY` option to access Airflow Ui via private IP address in a Transit Gateway connected to the VPN. VPC Endpoints are already created and integrated on the module for granting access to different resources required for the AWS MWAA. For more information, please see links below:

  - [MWAA Terraform documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/mwaa_environment#webserver_access_mode).
  - [Private routing without internet access](https://docs.aws.amazon.com/mwaa/latest/userguide/networking-about.html#networking-about-overview-private).
  - [VPC endpoints required for Apache Airflow](https://docs.aws.amazon.com/mwaa/latest/userguide/vpc-vpe-create-access.html#vpc-vpe-create-view-endpoints-examples).


- `logging_configuration` there are different types of `log_level` for the logging configuration that could be setup for the logs, default to `INFO`. For more information about the log level types, please see [Terraform logging configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/mwaa_environment#logging_configuration).

## Making changes

* Module have to be well documented and documentation should be kept up to date
* Keep in mind backward compatibility as other modules could reference the module
* Always format and validate configuration

### Versioning

We are following the principles of [Semantic Versioning](http://semver.org/). During initial development, the major
version is to 0 (e.g., `0.x.y`), which indicates the code does not yet have a stable API. Once we hit `1.0.0`, we will
follow these rules:

1. Increment the patch version for backwards-compatible bug fixes (e.g., `v1.0.8 -> v1.0.9`).
2. Increment the minor version for new features that are backwards-compatible (e.g., `v1.0.8 -> 1.1.0`).
3. Increment the major version for any backwards-incompatible changes (e.g. `1.0.8 -> 2.0.0`).

The version is defined using Git tags.
