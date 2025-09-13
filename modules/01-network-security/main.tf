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
  name                    = "my-3tier-app-vpc"
  auto_create_subnetworks = false
  project                 = "your-project-id-here"
}

# Create the Web Tier Subnet
resource "google_compute_subnetwork" "web_subnet" {
  name          = "test-web-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-central1"
  network       = google_compute_network.my_app_vpc.id
  project       = "your-project-id-here"
}

# Create the App Tier Subnet
resource "google_compute_subnetwork" "app_subnet" {
  name          = "test-app-subnet"
  ip_cidr_range = "10.0.2.0/24"
  region        = "us-central1"
  network       = google_compute_network.my_app_vpc.id
  project       = "your-project-id-here"
}

# Create the Data Tier Subnet
resource "google_compute_subnetwork" "data_subnet" {
  name          = "test-data-subnet"
  ip_cidr_range = "10.0.3.0/24"
  region        = "us-central1"
  network       = google_compute_network.my_app_vpc.id
  project       = "your-project-id-here"
}

# Allow public HTTP/HTTPS traffic to the web tier
resource "google_compute_firewall" "allow_http_https_web" {
  name     = "test-allow-http-https-web"
  network  = google_compute_network.my_app_vpc.name
  project  = "your-project-id-here"
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
  name     = "test-allow-ssh-web"
  network  = google_compute_network.my_app_vpc.name
  project  = "your-project-id-here"
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
  name     = "test-allow-web-to-app"
  network  = google_compute_network.my_app_vpc.name
  project  = "your-project-id-here"
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
  name     = "test-allow-app-to-db"
  network  = google_compute_network.my_app_vpc.name
  project  = "your-project-id-here"
  priority = 1003

  allow {
    protocol = "tcp"
    ports    = ["5432"]
  }

  source_tags = ["app-server"]
  target_tags = ["db-server"]
}