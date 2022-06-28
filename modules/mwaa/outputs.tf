##
## Output variables
##

output "mwaa_arn" {
  description = "The ARN of the MWAA Environment"
  value       = aws_mwaa_environment.mwaa_environment.arn
}

output "service_role_arn" {
  description = "The Service Role ARN of the Amazon MWAA Environment"
  value       = aws_mwaa_environment.mwaa_environment.service_role_arn
}

output "webserver_url" {
  description = "The webserver URL of the MWAA Environment"
  value       = aws_mwaa_environment.mwaa_environment.webserver_url
}