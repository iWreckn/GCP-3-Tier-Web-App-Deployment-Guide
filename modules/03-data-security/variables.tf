# -----------------------------------------------------------------------------
# MODULE 3: VARIABLE DECLARATIONS
# -----------------------------------------------------------------------------
# This file defines the input variables required for provisioning the
# secure Cloud SQL instance and its related resources.
# -----------------------------------------------------------------------------

variable "project_id" {
  description = "The ID of the Google Cloud project where resources will be deployed."
  type        = string
}

variable "region" {
  description = "The GCP region where the Cloud SQL instance will be created."
  type        = string
  default     = "us-central1"
}

variable "vpc_network_id" {
  description = "The self-link of the VPC network to connect the SQL instance to."
  type        = string
}

variable "db_name" {
  description = "The name of the database to be created within the Cloud SQL instance."
  type        = string
  default     = "my-app-db"
}

variable "app_db_user" {
  description = "The username for the application database user."
  type        = string
  default     = "myappuser"
}

variable "app_db_password" {
  description = "The password for the application database user. This should be a secure, generated value."
  type        = string
  sensitive   = true
}
