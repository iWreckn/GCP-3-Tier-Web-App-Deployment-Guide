terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

# -----------------------------------------------------------------------------
# MODULE 3: DATA SECURITY
# Converts gcloud commands from stepbystep guide into Terraform resources
# -----------------------------------------------------------------------------

# Phase 1: Private Database Infrastructure
# Equivalent to: gcloud compute addresses create google-managed-services-my-app-vpc
resource "google_compute_global_address" "private_ip_address" {
  name          = "google-managed-services-${var.vpc_network_name}"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = var.vpc_network_id
  project       = var.project_id
}

# Equivalent to: gcloud services vpc-peerings connect
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = var.vpc_network_id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

# Equivalent to: gcloud sql instances create secure-postgres-db
resource "google_sql_database_instance" "secure_postgres_db" {
  name             = "${var.environment}-secure-postgres-db"
  database_version = var.database_version
  region          = var.region
  project         = var.project_id

  # Prevent accidental deletion
  deletion_protection = var.environment == "prod" ? true : false

  settings {
    tier              = var.database_tier
    availability_type = var.environment == "prod" ? "REGIONAL" : "ZONAL"
    disk_type        = "PD_SSD"
    disk_size        = var.database_disk_size
    disk_autoresize  = true

    # Equivalent to: --backup-start-time=03:00 --enable-point-in-time-recovery
    backup_configuration {
      enabled                        = true
      start_time                    = "03:00"
      point_in_time_recovery_enabled = true
      transaction_log_retention_days = 7
      backup_retention_settings {
        retained_backups = var.environment == "prod" ? 30 : 7
        retention_unit   = "COUNT"
      }
    }

    # Equivalent to: --network=projects/[PROJECT]/global/networks/my-app-vpc --no-assign-ip
    ip_configuration {
      ipv4_enabled                                  = false
      private_network                              = var.vpc_network_id
      enable_private_path_for_google_cloud_services = true
    }

    # Equivalent to: --database-flags=log_connections=on,log_disconnections=on
    database_flags {
      name  = "log_connections"
      value = "on"
    }
    database_flags {
      name  = "log_disconnections"
      value = "on"
    }
    database_flags {
      name  = "log_checkpoints"
      value = "on"
    }
    database_flags {
      name  = "log_lock_waits"
      value = "on"
    }

    # Maintenance window
    maintenance_window {
      day          = 7  # Sunday
      hour         = 4  # 4 AM
      update_track = "stable"
    }
  }

  depends_on = [google_service_networking_connection.private_vpc_connection]
}

# Phase 2: Database Security Configuration
# Equivalent to: gcloud sql databases create appdb --instance=secure-postgres-db
resource "google_sql_database" "appdb" {
  name     = var.database_name
  instance = google_sql_database_instance.secure_postgres_db.name
  project  = var.project_id

  charset   = "UTF8"
  collation = "en_US.UTF8"
}

# Equivalent to: gcloud sql users create appuser --instance=secure-postgres-db --password="[PASSWORD]"
resource "google_sql_user" "appuser" {
  name     = var.app_db_username
  instance = google_sql_database_instance.secure_postgres_db.name
  project  = var.project_id
  password = var.app_db_password
  host     = "%"
}

# Equivalent to: gcloud sql users create readonly_user --instance=secure-postgres-db --password="[PASSWORD]"
resource "google_sql_user" "readonly_user" {
  name     = "${var.app_db_username}_readonly"
  instance = google_sql_database_instance.secure_postgres_db.name
  project  = var.project_id
  password = var.readonly_db_password
  host     = "%"
}

# Equivalent to: gcloud compute firewall-rules create allow-app-to-database
resource "google_compute_firewall" "allow_app_to_database" {
  name    = "${var.environment}-allow-app-to-database"
  network = var.vpc_network_name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["5432"]
  }

  source_tags = ["app-server"]
  target_tags = ["database-server"]

  # Equivalent to: --enable-logging
  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}

# Equivalent to: gcloud compute firewall-rules create allow-admin-to-database
resource "google_compute_firewall" "allow_admin_to_database" {
  name    = "${var.environment}-allow-admin-to-database"
  network = var.vpc_network_name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["5432"]
  }

  source_ranges = var.admin_ip_ranges
  target_tags   = ["database-server"]

  # Equivalent to: --enable-logging
  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}

# Phase 3: Secure Storage and Secrets
# Equivalent to: gsutil mb -p [PROJECT_ID] -l us-central1 gs://[PROJECT_ID]-app-data
resource "google_storage_bucket" "app_data_bucket" {
  name          = "${var.project_id}-${var.environment}-app-data"
  location      = var.region
  project       = var.project_id
  force_destroy = var.environment != "prod"

  # Equivalent to: gsutil uniformbucketlevelaccess set on
  uniform_bucket_level_access = true

  # Equivalent to: gsutil versioning set on
  versioning {
    enabled = true
  }

  # Equivalent to: gsutil lifecycle set lifecycle.json (Delete after 90 days)
  lifecycle_rule {
    condition {
      age = var.environment == "prod" ? 90 : 30
    }
    action {
      type = "Delete"
    }
  }

  # Enable encryption at rest
  encryption {
    default_kms_key_name = var.kms_key_name != "" ? var.kms_key_name : null
  }
}

# Equivalent to: gcloud secrets create db-connection-string --data-file=-
resource "google_secret_manager_secret" "db_connection_string" {
  secret_id = "${var.environment}-db-connection-string"
  project   = var.project_id

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

# Store the database connection string
resource "google_secret_manager_secret_version" "db_connection_string_version" {
  secret = google_secret_manager_secret.db_connection_string.id
  secret_data = "postgresql://${google_sql_user.appuser.name}:${var.app_db_password}@${google_sql_database_instance.secure_postgres_db.private_ip_address}:5432/${google_sql_database.appdb.name}?sslmode=require"
}

# Phase 4: Access Controls and Monitoring
# Equivalent to: gcloud secrets add-iam-policy-binding db-connection-string
resource "google_secret_manager_secret_iam_member" "app_secret_access" {
  secret_id = google_secret_manager_secret.db_connection_string.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${var.app_service_account_email}"
  project   = var.project_id
}

# Equivalent to: gsutil iam ch serviceAccount:app-tier-sa@[PROJECT].iam.gserviceaccount.com:objectAdmin
resource "google_storage_bucket_iam_member" "app_bucket_access" {
  bucket = google_storage_bucket.app_data_bucket.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${var.app_service_account_email}"
}

# Grant readonly user access to bucket for reporting
resource "google_storage_bucket_iam_member" "readonly_bucket_access" {
  count  = var.readonly_service_account_email != "" ? 1 : 0
  bucket = google_storage_bucket.app_data_bucket.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${var.readonly_service_account_email}"
}

# Equivalent to: gcloud alpha monitoring channels create
resource "google_monitoring_notification_channel" "database_alerts" {
  count        = length(var.notification_emails) > 0 ? length(var.notification_emails) : 0
  display_name = "Database Alerts - ${var.notification_emails[count.index]}"
  type         = "email"
  project      = var.project_id

  labels = {
    email_address = var.notification_emails[count.index]
  }
}

# Create monitoring alert for database connections
resource "google_monitoring_alert_policy" "database_connection_alert" {
  display_name = "${var.environment} Database Connection Alert"
  project      = var.project_id
  combiner     = "OR"

  conditions {
    display_name = "Database connection count"
    
    condition_threshold {
      filter          = "resource.type=\"cloudsql_database\" AND resource.labels.database_id=\"${var.project_id}:${google_sql_database_instance.secure_postgres_db.name}\""
      duration        = "300s"
      comparison      = "COMPARISON_GREATER_THAN"
      threshold_value = var.max_database_connections

      aggregations {
        alignment_period   = "300s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }

  notification_channels = [for channel in google_monitoring_notification_channel.database_alerts : channel.id]

  alert_strategy {
    auto_close = "1800s"
  }
}

# Equivalent to: gcloud logging sinks create database-audit-sink
resource "google_logging_project_sink" "database_audit_sink" {
  name        = "${var.environment}-database-audit-sink"
  destination = "storage.googleapis.com/${google_storage_bucket.app_data_bucket.name}/audit-logs"
  project     = var.project_id

  # Filter for database-related logs
  filter = "resource.type=\"cloudsql_database\""

  unique_writer_identity = true
}

# Grant the log sink permission to write to the bucket
resource "google_storage_bucket_iam_member" "audit_log_writer" {
  bucket = google_storage_bucket.app_data_bucket.name
  role   = "roles/storage.objectCreator"
  member = google_logging_project_sink.database_audit_sink.writer_identity
}
