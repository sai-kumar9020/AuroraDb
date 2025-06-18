variable "secret_name" {
  description = "Name of the secret in AWS Secrets Manager"
  type        = string
}

variable "secret_description" {
  description = "Description of the secret"
  type        = string
  default     = "Database credentials for Aurora cluster"
}

variable "username" {
  description = "Database master username"
  type        = string
  default     = "admin"
}

variable "password_length" {
  description = "Length of the generated password"
  type        = number
  default     = 16
}

variable "recovery_window_in_days" {
  description = "Number of days that AWS Secrets Manager waits before it can delete the secret"
  type        = number
  default     = 7
}

variable "create_access_policy" {
  description = "Whether to create an IAM policy for accessing the secret"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}