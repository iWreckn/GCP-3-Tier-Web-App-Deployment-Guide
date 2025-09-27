output "database_instance_name" {
  description = "Name of the Cloud SQL database instance."
  value       = google_sql_database_instance.secure_postgres_db.name
}

output "database_instance_connection_name" {
  description = "Connection name for the Cloud SQL instance."
  value       = google_sql_database_instance.secure_postgres_db.connection_name
}

output "database_private_ip" {
  description = "Private IP address of the database instance."
  value       = google_sql_database_instance.secure_postgres_db.private_ip_address
  sensitive   = true
}

output "database_name" {
  description = "Name of the application database."
  value       = google_sql_database.appdb.name
}

output "app_database_user" {
  description = "Application database username."
  value       = google_sql_user.appuser.name
}

output "readonly_database_user" {
  description = "Read-only database username."
  value       = google_sql_user.readonly_user.name
}

output "storage_bucket_name" {
  description = "Name of the application data storage bucket."
  value       = google_storage_bucket.app_data_bucket.name
}

output "storage_bucket_url" {
  description = "URL of the application data storage bucket."
  value       = google_storage_bucket.app_data_bucket.url
}

output "db_connection_secret_name" {
  description = "Name of the Secret Manager secret containing database connection string."
  value       = google_secret_manager_secret.db_connection_string.secret_id
}
