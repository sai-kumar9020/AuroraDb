output "secret_arn" {
  description = "ARN of the secret"
  value       = aws_secretsmanager_secret.db_credentials.arn
}

output "secret_name" {
  description = "Name of the secret"
  value       = aws_secretsmanager_secret.db_credentials.name
}

output "secret_id" {
  description = "ID of the secret"
  value       = aws_secretsmanager_secret.db_credentials.id
}

output "username" {
  description = "Database username"
  value       = var.username
}

output "password" {
  description = "Generated database password"
  value       = random_password.db_password.result
  sensitive   = true
}

output "access_policy_arn" {
  description = "ARN of the IAM policy for accessing the secret"
  value       = var.create_access_policy ? aws_iam_policy.secrets_access[0].arn : null
}