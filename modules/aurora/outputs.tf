output "cluster_arn" {
  description = "Amazon Resource Name (ARN) of cluster"
  value       = aws_rds_cluster.aurora.arn
}

output "cluster_id" {
  description = "The RDS Cluster Identifier"
  value       = aws_rds_cluster.aurora.cluster_identifier
}

output "cluster_resource_id" {
  description = "The RDS Cluster Resource ID"
  value       = aws_rds_cluster.aurora.cluster_resource_id
}

output "cluster_members" {
  description = "List of RDS Instances that are a part of this cluster"
  value       = aws_rds_cluster.aurora.cluster_members
}

output "cluster_endpoint" {
  description = "Writer endpoint for the cluster"
  value       = aws_rds_cluster.aurora.endpoint
}

output "cluster_reader_endpoint" {
  description = "Reader endpoint for the cluster"
  value       = aws_rds_cluster.aurora.reader_endpoint
}

output "cluster_engine_version_actual" {
  description = "The running version of the cluster database"
  value       = aws_rds_cluster.aurora.engine_version_actual
}

output "cluster_database_name" {
  description = "Name for an automatically created database on cluster creation"
  value       = aws_rds_cluster.aurora.database_name
}

output "cluster_port" {
  description = "The database port"
  value       = aws_rds_cluster.aurora.port
}

output "cluster_master_username" {
  description = "The database master username"
  value       = aws_rds_cluster.aurora.master_username
  sensitive   = true
}

output "cluster_hosted_zone_id" {
  description = "The Route53 Hosted Zone ID of the endpoint"
  value       = aws_rds_cluster.aurora.hosted_zone_id
}

output "instance_endpoints" {
  description = "List of RDS instance endpoints"
  value       = aws_rds_cluster_instance.aurora_instances[*].endpoint
}

output "instance_identifiers" {
  description = "List of RDS instance identifiers"
  value       = aws_rds_cluster_instance.aurora_instances[*].identifier
}

output "db_subnet_group_name" {
  description = "The db subnet group name"
  value       = aws_db_subnet_group.aurora.name
}