variable "name_prefix" {
  description = "Name prefix for resources"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where to create security group"
  type        = string
}

variable "database_port" {
  description = "The port on which the DB accepts connections"
  type        = number
  default     = 3306
}

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

variable "create_monitoring_role" {
  description = "Whether to create IAM role for enhanced monitoring"
  type        = bool
  default     = true
}

variable "create_kms_key" {
  description = "Whether to create KMS key for encryption"
  type        = bool
  default     = true
}

variable "kms_key_deletion_window" {
  description = "The waiting period, specified in number of days"
  type        = number
  default     = 7
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}