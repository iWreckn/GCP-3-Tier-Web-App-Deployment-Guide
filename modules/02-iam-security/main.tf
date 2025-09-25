# -----------------------------------------------------------------------------
# MODULE 2: IAM & SERVICE ACCOUNTS
# Defines least-privilege service accounts for each application tier.
# -----------------------------------------------------------------------------

# Service Account for the Web Tier VMs
resource "google_service_account" "web_tier_sa" {
  project      = var.project_id
  account_id   = "web-tier-sa-${var.environment}"
  display_name = "Web Tier Service Account"
  description  = "Least privilege identity for web tier instances"
}

# Service Account for the App Tier VMs
resource "google_service_account" "app_tier_sa" {
  project      = var.project_id
  account_id   = "app-tier-sa-${var.environment}"
  display_name = "App Tier Service Account"
  description  = "Least privilege identity for app tier instances"
}

# Service Account for a database administrator/tool
resource "google_service_account" "db_admin_sa" {
  project      = var.project_id
  account_id   = "db-admin-sa-${var.environment}"
  display_name = "Database Admin Service Account"
  description  = "Identity for tools or users that need to connect to the SQL DB"
}

# Grant the Cloud SQL Client role to the DB Admin Service Account
resource "google_project_iam_member" "db_admin_iam" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.db_admin_sa.email}"
}

