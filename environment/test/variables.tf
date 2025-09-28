variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "us-south1"
}

variable "environment" {
  description = "Environment name (test, production)"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
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