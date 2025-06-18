variable "cluster_identifier" {
  description = "The cluster identifier"
  type        = string
}

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

variable "secret_id" {
  description = "The ID of the secret containing database credentials"
  type        = string
}

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

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate"
  type        = list(string)
}

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

variable "storage_encrypted" {
  description = "Specifies whether the DB cluster is encrypted"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "The ARN for the KMS encryption key"
  type        = string
  default     = null
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

variable "monitoring_interval" {
  description = "The interval for collecting enhanced monitoring metrics"
  type        = number
  default     = 60
}

variable "monitoring_role_arn" {
  description = "The ARN for the IAM role for enhanced monitoring"
  type        = string
  default     = null
}

variable "auto_minor_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically"
  type        = bool
  default     = true
}

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

variable "db_cluster_parameter_group_name" {
  description = "A cluster parameter group to associate with the cluster"
  type        = string
  default     = null
}

variable "db_parameter_group_name" {
  description = "The name of the DB parameter group to associate with instances"
  type        = string
  default     = null
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

variable "restore_to_point_in_time" {
  description = "Configuration for restoring from point in time"
  type = object({
    source_cluster_identifier  = string
    restore_type              = optional(string)
    use_latest_restorable_time = optional(bool)
    restore_to_time           = optional(string)
  })
  default = null
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}