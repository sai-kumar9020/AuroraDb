# Data source to retrieve credentials from Secrets Manager
data "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = var.secret_id
}

locals {
  db_credentials = jsondecode(data.aws_secretsmanager_secret_version.db_credentials.secret_string)
}

# Create DB subnet group
resource "aws_db_subnet_group" "aurora" {
  name       = "${var.cluster_identifier}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(var.tags, {
    Name = "${var.cluster_identifier}-subnet-group"
  })
}

# Create DB parameter group for cluster
resource "aws_rds_cluster_parameter_group" "aurora" {
  count  = var.create_cluster_parameter_group ? 1 : 0
  family = var.parameter_group_family
  name   = "${var.cluster_identifier}-cluster-params"

  dynamic "parameter" {
    for_each = var.cluster_parameters
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }

  tags = var.tags
}

# Create DB parameter group for instances
resource "aws_db_parameter_group" "aurora" {
  count  = var.create_db_parameter_group ? 1 : 0
  family = var.parameter_group_family
  name   = "${var.cluster_identifier}-db-params"

  dynamic "parameter" {
    for_each = var.db_parameters
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }

  tags = var.tags
}

# Create Aurora cluster
resource "aws_rds_cluster" "aurora" {
  cluster_identifier              = var.cluster_identifier
  engine                         = var.engine
  engine_version                 = var.engine_version
  database_name                  = var.database_name
  master_username                = local.db_credentials.username
  master_password                = local.db_credentials.password
  backup_retention_period        = var.backup_retention_period
  preferred_backup_window        = var.preferred_backup_window
  preferred_maintenance_window   = var.preferred_maintenance_window
  db_subnet_group_name          = aws_db_subnet_group.aurora.name
  vpc_security_group_ids        = var.vpc_security_group_ids
  storage_encrypted             = var.storage_encrypted
  kms_key_id                    = var.kms_key_id
  deletion_protection           = var.deletion_protection
  skip_final_snapshot           = var.skip_final_snapshot
  final_snapshot_identifier     = var.skip_final_snapshot ? null : "${var.cluster_identifier}-final-snapshot-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"
  copy_tags_to_snapshot         = var.copy_tags_to_snapshot
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  
  db_cluster_parameter_group_name = var.create_cluster_parameter_group ? aws_rds_cluster_parameter_group.aurora[0].name : var.db_cluster_parameter_group_name

  dynamic "restore_to_point_in_time" {
    for_each = var.restore_to_point_in_time != null ? [var.restore_to_point_in_time] : []
    content {
      source_cluster_identifier  = restore_to_point_in_time.value.source_cluster_identifier
      restore_type              = restore_to_point_in_time.value.restore_type
      use_latest_restorable_time = restore_to_point_in_time.value.use_latest_restorable_time
      restore_to_time           = restore_to_point_in_time.value.restore_to_time
    }
  }

  tags = merge(var.tags, {
    Name = var.cluster_identifier
  })

  lifecycle {
    ignore_changes = [
      master_password,
    ]
  }
}

# Create Aurora cluster instances
resource "aws_rds_cluster_instance" "aurora_instances" {
  count              = var.instance_count
  identifier         = "${var.cluster_identifier}-${count.index + 1}"
  cluster_identifier = aws_rds_cluster.aurora.id
  instance_class     = var.instance_class
  engine             = aws_rds_cluster.aurora.engine
  engine_version     = aws_rds_cluster.aurora.engine_version
  
  performance_insights_enabled    = var.performance_insights_enabled
  performance_insights_kms_key_id = var.performance_insights_kms_key_id
  monitoring_interval             = var.monitoring_interval
  monitoring_role_arn            = var.monitoring_role_arn
  
  db_parameter_group_name = var.create_db_parameter_group ? aws_db_parameter_group.aurora[0].name : var.db_parameter_group_name
  
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  
  tags = merge(var.tags, {
    Name = "${var.cluster_identifier}-${count.index + 1}"
  })
}