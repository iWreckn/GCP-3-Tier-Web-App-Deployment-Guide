# -----------------------------------------------------------------------------
# MODULE 3: DATA TIER - SECURE CLOUD SQL
# -----------------------------------------------------------------------------
# This module provisions a secure Cloud SQL for PostgreSQL instance.
# It follows security best practices by:
# 1. Disabling the public IP address to prevent exposure to the internet.
# 2. Establishing a private service connection to the VPC for secure, internal communication.
# 3. Automatically generating and storing the database root password in Secret Manager.
# -----------------------------------------------------------------------------

# --- 1. API Activation ---
# APIs must be enabled before their resources can be used.

# Enable the Secret Manager API for secure password storage
resource "google_project_service" "secretmanager" {
  project = var.project_id
  service = "secretmanager.googleapis.com"
}

# Enable the Service Networking API for private connections
resource "google_project_service" "servicenetworking" {
  project = var.project_id
  service = "servicenetworking.googleapis.com"
}

# Enable the Cloud SQL Admin API to manage database instances
resource "google_project_service" "sqladmin" {
  project = var.project_id
  service = "sqladmin.googleapis.com"
}

# --- 2. Password and Secret Management ---
# Automate the creation and secure storage of the database password.

# Generate a random password for the database root user
resource "random_password" "db_password" {
  length  = 20
  special = true
}

# Create a secret in Secret Manager to hold the password
resource "google_secret_manager_secret" "db_password_secret" {
  # Ensure the Secret Manager API is enabled first
  depends_on = [google_project_service.secretmanager]

  project   = var.project_id
  secret_id = "db-root-password"

  replication {
    auto {}
  }
}

# Add the generated password as a version to the secret
resource "google_secret_manager_secret_version" "db_password_secret_version" {
  secret      = google_secret_manager_secret.db_password_secret.id
  secret_data = random_password.db_password.result
}

# --- 3. Private Network Configuration ---
# Configure the VPC to allow a private, secure connection to the Cloud SQL instance.

# Reserve a private IP address range for Google services to connect to the VPC
resource "google_compute_global_address" "private_ip_alloc" {
  # Ensure the Service Networking API is enabled first
  depends_on = [google_project_service.servicenetworking]

  project       = var.project_id
  name          = "private-service-access-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  ip_version    = "IPV4"
  prefix_length = 16
  network       = var.vpc_network_id
}

# Create the private service connection between the VPC and Google services
resource "google_service_networking_connection" "default" {
  # Ensure the IP range has been allocated first
  depends_on = [google_compute_global_address.private_ip_alloc]

  network                 = var.vpc_network_id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]
}

# --- 4. Cloud SQL Instance Creation ---
# Provision the PostgreSQL database instance with security-focused settings.

# Create the Cloud SQL for PostgreSQL instance
resource "google_sql_database_instance" "my_app_db" {
  # Wait for the private network connection and SQL API to be ready
  depends_on = [
    google_service_networking_connection.default,
    google_project_service.sqladmin
  ]

  project          = var.project_id
  name             = "my-app-db"
  database_version = "POSTGRES_13"
  region           = var.region

  # Use the password generated and stored securely
  root_password = random_password.db_password.result

  settings {
    # CHEAPEST PostgreSQL option for testing (~$7/month)
    tier = "db-f1-micro"

    # --- Critical Security Configurations ---
    ip_configuration {
      ipv4_enabled    = false # Disables Public IP
      private_network = var.vpc_network_id
    }

    # SSL is enforced through ip_configuration settings
    # PostgreSQL automatically requires SSL for connections when private_network is used

    backup_configuration {
      enabled = true
    }
  }

  # Prevent accidental deletion of the production database
  deletion_protection = false
}

# Create the specific database within the instance
resource "google_sql_database" "my_app_database" {
  project  = var.project_id
  instance = google_sql_database_instance.my_app_db.name
  name     = var.db_name
}

# Create a dedicated user for the application
resource "google_sql_user" "my_app_user" {
  project  = var.project_id
  instance = google_sql_database_instance.my_app_db.name
  name     = var.app_db_user
  password = var.app_db_password
}