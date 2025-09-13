terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

# Create Custom VPC
resource "google_compute_network" "my_app_vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
  project                 = var.project_id
}

# Create the Web Tier Subnet
resource "google_compute_subnetwork" "web_subnet" {
  name          = "${var.environment}-web-subnet"
  ip_cidr_range = var.web_subnet_cidr
  region        = var.region
  network       = google_compute_network.my_app_vpc.id
  project       = var.project_id
}

# Create the App Tier Subnet
resource "google_compute_subnetwork" "app_subnet" {
  name          = "${var.environment}-app-subnet"
  ip_cidr_range = var.app_subnet_cidr
  region        = var.region
  network       = google_compute_network.my_app_vpc.id
  project       = var.project_id
}

# Create the Data Tier Subnet
resource "google_compute_subnetwork" "data_subnet" {
  name          = "${var.environment}-data-subnet"
  ip_cidr_range = var.data_subnet_cidr
  region        = var.region
  network       = google_compute_network.my_app_vpc.id
  project       = var.project_id
}

# Allow public HTTP/HTTPS traffic to the web tier
resource "google_compute_firewall" "allow_http_https_web" {
  name     = "${var.environment}-allow-http-https-web"
  network  = google_compute_network.my_app_vpc.name
  project  = var.project_id
  priority = 1000

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web-server"]
}

# Allow SSH access to web tier
resource "google_compute_firewall" "allow_ssh_web" {
  name     = "${var.environment}-allow-ssh-web"
  network  = google_compute_network.my_app_vpc.name
  project  = var.project_id
  priority = 1001

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"] # Lock this down in production!
  target_tags   = ["web-server"]
}

# Allow web tier to communicate with app tier
resource "google_compute_firewall" "allow_web_to_app" {
  name     = "${var.environment}-allow-web-to-app"
  network  = google_compute_network.my_app_vpc.name
  project  = var.project_id
  priority = 1002

  allow {
    protocol = "tcp"
    ports    = ["3000"]
  }

  source_tags = ["web-server"]
  target_tags = ["app-server"]
}

# Allow app tier to communicate with data tier
resource "google_compute_firewall" "allow_app_to_db" {
  name     = "${var.environment}-allow-app-to-db"
  network  = google_compute_network.my_app_vpc.name
  project  = var.project_id
  priority = 1003

  allow {
    protocol = "tcp"
    ports    = ["5432"]
  }

  source_tags = ["app-server"]
  target_tags = ["db-server"]
}