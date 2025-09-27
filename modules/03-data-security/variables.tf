variable "project_id" {
  description = "The GCP project ID where resources will be created."
  type        = string
}

variable "region" {
  description = "The GCP region for the network resources."
  type        = string
}

variable "environment" {
  description = "The name of the environment (e.g., 'dev', 'test', 'prod')."
  type        = string
}

variable "vpc_network_name" {
  description = "The name of the VPC network from Module 1."
  type        = string
}

variable "vpc_network_id" {
  description = "The ID of the VPC network from Module 1."
  type        = string
}

variable "database_version" {
  description = "PostgreSQL version for Cloud SQL."
  type        = string
  default     = "POSTGRES_15"
}

variable "database_tier" {
  description = "Machine type for the database instance."
  type        = string
  default     = "db-f1-micro"
}

variable "database_disk_size" {
  description = "Initial disk size for the database in GB."
  type        = number
  default     = 20
}

variable "database_name" {
  description = "Name of the application database."
  type        = string
  default     = "appdb"
}

variable "app_db_username" {
  description = "Username for the application database user."
  type        = string
  default     = "appuser"
}

variable "app_db_password" {
  description = "Password for the application database user."
  type        = string
  sensitive   = true
}

variable "readonly_db_password" {
  description = "Password for the read-only database user."
  type        = string
  sensitive   = true
}

variable "app_service_account_email" {
  description = "Email of the app tier service account from Module 2."
  type        = string
}

variable "readonly_service_account_email" {
  description = "Email of a read-only service account (optional)."
  type        = string
  default     = ""
}

variable "admin_ip_ranges" {
  description = "IP ranges allowed for database administration."
  type        = list(string)
  default     = []
}

variable "kms_key_name" {
  description = "KMS key name for encryption (optional)."
  type        = string
  default     = ""
}

variable "max_database_connections" {
  description = "Maximum number of database connections before alerting."
  type        = number
  default     = 80
}

variable "notification_emails" {
  description = "List of email addresses for monitoring alerts."
  type        = list(string)
  default     = []
}
