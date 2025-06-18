variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "demo-aurora"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

# variable "vpc_id" {
#   description = "ID of the VPC where resources will be created"
#   type        = string
# }

# variable "subnet_ids" {
#   description = "List of subnet IDs for the Aurora cluster"
#   type        = list(string)
#   default     = []
# }

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones to use for the subnets"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for the private subnets"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

# Database Configuration
variable "engine" {
  description = "The database engine"
  type        = string
  default     = "aurora-mysql"
  
  validation {
    condition     = contains(["aurora-mysql", "aurora-postgresql"], var.engine)
    error_message = "Engine must be either aurora-mysql or aurora-postgresql."
  }
}

variable "engine_version" {
  description = "The engine version"
  type        = string
  default     = null
}

variable "database_name" {
  description = "The name of the database to create when the DB instance is created"
  type        = string
  default     = null
}

variable "database_username" {
  description = "Database master username"
  type        = string
  default     = "admin"
}

variable "password_length" {
  description = "Length of the generated password"
  type        = number
  default     = 16
}

variable "database_port" {
  description = "The port on which the DB accepts connections"
  type        = number
  default     = 3306
}

# Instance Configuration
variable "instance_count" {
  description = "Number of instances in the cluster"
  type        = number
  default     = 2
}

variable "instance_class" {
  description = "The instance class to use"
  type        = string
  default     = "db.r6g.large"
}

# Backup Configuration
variable "backup_retention_period" {
  description = "The backup retention period"
  type        = number
  default     = 7
}

variable "preferred_backup_window" {
  description = "The preferred backup window"
  type        = string
  default     = "03:00-04:00"
}

variable "preferred_maintenance_window" {
  description = "The preferred maintenance window"
  type        = string
  default     = "sun:04:00-sun:05:00"
}

# Security Configuration
variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to access the database"
  type        = list(string)
  default     = []
}

variable "allowed_security_groups" {
  description = "List of security group IDs allowed to access the database"
  type        = list(string)
  default     = []
}

variable "storage_encrypted" {
  description = "Specifies whether the DB cluster is encrypted"
  type        = bool
  default     = true
}

variable "create_kms_key" {
  description = "Whether to create KMS key for encryption"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "The ARN for the KMS encryption key (if not creating new one)"
  type        = string
  default     = null
}

variable "kms_key_deletion_window" {
  description = "The waiting period, specified in number of days"
  type        = number
  default     = 7
}

variable "deletion_protection" {
  description = "If the DB instance should have deletion protection enabled"
  type        = bool
  default     = true
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted"
  type        = bool
  default     = false
}

variable "copy_tags_to_snapshot" {
  description = "Copy all Cluster tags to snapshots"
  type        = bool
  default     = true
}

# Monitoring Configuration
variable "enabled_cloudwatch_logs_exports" {
  description = "List of log types to export to cloudwatch"
  type        = list(string)
  default     = []
}

variable "performance_insights_enabled" {
  description = "Specifies whether Performance Insights are enabled"
  type        = bool
  default     = true
}

variable "performance_insights_kms_key_id" {
  description = "The ARN for the KMS key to encrypt Performance Insights data"
  type        = string
  default     = null
}

variable "enable_enhanced_monitoring" {
  description = "Whether to enable enhanced monitoring"
  type        = bool
  default     = true
}

variable "monitoring_interval" {
  description = "The interval for collecting enhanced monitoring metrics"
  type        = number
  default     = 60
}

variable "auto_minor_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically"
  type        = bool
  default     = true
}

# Parameter Groups
variable "create_cluster_parameter_group" {
  description = "Whether to create a cluster parameter group"
  type        = bool
  default     = false
}

variable "create_db_parameter_group" {
  description = "Whether to create a DB parameter group"
  type        = bool
  default     = false
}

variable "parameter_group_family" {
  description = "The DB parameter group family"
  type        = string
  default     = "aurora-mysql8.0"
}

variable "cluster_parameters" {
  description = "A list of cluster parameters to apply"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "db_parameters" {
  description = "A list of DB parameters to apply"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

# Secrets Manager Configuration
variable "secret_recovery_window" {
  description = "Number of days that AWS Secrets Manager waits before it can delete the secret"
  type        = number
  default     = 7
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}