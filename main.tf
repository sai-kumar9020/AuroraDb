module "vpc" {
  source = "./modules/vpc"
  
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
#   tags                 = local.common_tags
}

# Create secrets manager secret and credentials
module "secrets_manager" {
  source = "./modules/secrets-manager"

  secret_name                = "${var.project_name}-aurora-credentials"
  secret_description         = "Aurora database credentials for ${var.project_name}"
  username                   = var.database_username
  password_length            = var.password_length
  recovery_window_in_days    = var.secret_recovery_window
  create_access_policy       = true

  tags = local.common_tags
}

# Create security resources
module "security" {
  source = "./modules/security"

  name_prefix               = var.project_name
  vpc_id                   = module.vpc.vpc_id
  database_port            = var.database_port
  allowed_cidr_blocks      = var.allowed_cidr_blocks
  allowed_security_groups  = var.allowed_security_groups
  create_monitoring_role   = var.enable_enhanced_monitoring
  create_kms_key          = var.create_kms_key
  kms_key_deletion_window = var.kms_key_deletion_window

  tags = local.common_tags
}

# Create Aurora cluster
module "aurora" {
  source = "./modules/aurora"

  cluster_identifier                = "${var.project_name}-aurora"
  engine                           = var.engine
  engine_version                   = var.engine_version
  database_name                    = var.database_name
  secret_id                        = module.secrets_manager.secret_id
  instance_count                   = var.instance_count
  instance_class                   = var.instance_class
#   subnet_ids                       = length(var.subnet_ids) > 0 ? var.subnet_ids : data.aws_subnets.database.ids
  subnet_ids                       = module.vpc.private_subnet_ids
  vpc_security_group_ids           = [module.security.security_group_id]
  backup_retention_period          = var.backup_retention_period
  preferred_backup_window          = var.preferred_backup_window
  preferred_maintenance_window     = var.preferred_maintenance_window
  storage_encrypted                = var.storage_encrypted
  kms_key_id                       = var.create_kms_key ? module.security.kms_key_arn : var.kms_key_id
  deletion_protection              = var.deletion_protection
  skip_final_snapshot              = var.skip_final_snapshot
  copy_tags_to_snapshot            = var.copy_tags_to_snapshot
  enabled_cloudwatch_logs_exports  = var.enabled_cloudwatch_logs_exports
  performance_insights_enabled     = var.performance_insights_enabled
  performance_insights_kms_key_id  = var.create_kms_key ? module.security.kms_key_arn : var.performance_insights_kms_key_id
  monitoring_interval              = var.enable_enhanced_monitoring ? var.monitoring_interval : 0
  monitoring_role_arn              = var.enable_enhanced_monitoring ? module.security.monitoring_role_arn : null
  auto_minor_version_upgrade       = var.auto_minor_version_upgrade
  create_cluster_parameter_group   = var.create_cluster_parameter_group
  create_db_parameter_group        = var.create_db_parameter_group
  parameter_group_family           = var.parameter_group_family
  cluster_parameters               = var.cluster_parameters
  db_parameters                    = var.db_parameters

  tags = local.common_tags

  depends_on = [module.secrets_manager]
}

# Local values
locals {
  common_tags = merge(var.tags, {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  })
}