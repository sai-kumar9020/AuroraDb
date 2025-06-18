output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = module.vpc.private_subnet_ids
}

# Secrets Manager Outputs
output "secret_arn" {
  description = "ARN of the secret containing database credentials"
  value       = module.secrets_manager.secret_arn
}

output "secret_name" {
  description = "Name of the secret containing database credentials"
  value       = module.secrets_manager.secret_name
}

# Aurora Cluster Outputs
output "cluster_arn" {
  description = "Amazon Resource Name (ARN) of cluster"
  value       = module.aurora.cluster_arn
}

output "cluster_id" {
  description = "The RDS Cluster Identifier"
  value       = module.aurora.cluster_id
}

output "cluster_endpoint" {
  description = "Writer endpoint for the cluster"
  value       = module.aurora.cluster_endpoint
}

output "cluster_reader_endpoint" {
  description = "Reader endpoint for the cluster"
  value       = module.aurora.cluster_reader_endpoint
}

output "cluster_port" {
  description = "The database port"
  value       = module.aurora.cluster_port
}

output "cluster_database_name" {
  description = "Name for an automatically created database on cluster creation"
  value       = module.aurora.cluster_database_name
}

output "cluster_master_username" {
  description = "The database master username"
  value       = module.aurora.cluster_master_username
  sensitive   = true
}

output "instance_endpoints" {
  description = "List of RDS instance endpoints"
  value       = module.aurora.instance_endpoints
}

output "instance_identifiers" {
  description = "List of RDS instance identifiers"
  value       = module.aurora.instance_identifiers
}

# Security Outputs
output "security_group_id" {
  description = "ID of the security group"
  value       = module.security.security_group_id
}

output "kms_key_id" {
  description = "The globally unique identifier for the key"
  value       = module.security.kms_key_id
}

output "kms_key_arn" {
  description = "The Amazon Resource Name (ARN) of the key"
  value       = module.security.kms_key_arn
}

# Connection Information
output "connection_info" {
  description = "Database connection information"
  value = {
    endpoint        = module.aurora.cluster_endpoint
    reader_endpoint = module.aurora.cluster_reader_endpoint
    port           = module.aurora.cluster_port
    database_name  = module.aurora.cluster_database_name
    username       = module.aurora.cluster_master_username
    secret_arn     = module.secrets_manager.secret_arn
  }
  sensitive = true
}