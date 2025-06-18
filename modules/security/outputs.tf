output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.aurora.id
}

output "security_group_arn" {
  description = "ARN of the security group"
  value       = aws_security_group.aurora.arn
}

output "monitoring_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the monitoring role"
  value       = var.create_monitoring_role ? aws_iam_role.enhanced_monitoring[0].arn : null
}

output "kms_key_id" {
  description = "The globally unique identifier for the key"
  value       = var.create_kms_key ? aws_kms_key.aurora[0].key_id : null
}

output "kms_key_arn" {
  description = "The Amazon Resource Name (ARN) of the key"
  value       = var.create_kms_key ? aws_kms_key.aurora[0].arn : null
}

output "kms_alias_arn" {
  description = "The Amazon Resource Name (ARN) of the key alias"
  value       = var.create_kms_key ? aws_kms_alias.aurora[0].arn : null
}