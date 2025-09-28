# -----------------------------------------------------------------------------
# MODULE 3: OUTPUT DEFINITIONS
# -----------------------------------------------------------------------------
# This file defines the output values from the Terraform module. These outputs
# can be used to connect other resources or for querying deployment details.
# -----------------------------------------------------------------------------

output "cloud_sql_instance_name" {
  description = "The full name of the created Cloud SQL instance."
  value       = google_sql_database_instance.my_app_db.name
}

output "cloud_sql_instance_private_ip" {
  description = "The private IP address of the Cloud SQL instance, used for connections from within the VPC."
  value       = google_sql_database_instance.my_app_db.private_ip_address
}

output "db_password_secret_name" {
  description = "The resource name of the Secret Manager secret containing the database root password."
  value       = google_secret_manager_secret.db_password_secret.secret_id
}

