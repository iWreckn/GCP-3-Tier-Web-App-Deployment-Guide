# Outputs for the IAM module, making the service account emails available
# to other modules that will need to attach them to resources (like VMs).

output "web_tier_sa_email" {
  description = "The email of the web tier service account."
  value       = google_service_account.web_tier_sa.email
}

output "app_tier_sa_email" {
  description = "The email of the app tier service account."
  value       = google_service_account.app_tier_sa.email
}

output "db_admin_sa_email" {
  description = "The email of the database admin service account."
  value       = google_service_account.db_admin_sa.email
}

