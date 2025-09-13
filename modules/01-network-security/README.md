# Module 1: Building a Secure Network Foundation

Welcome to the first hands-on module of the GCP Security Training Lab! In this section, we'll lay the most critical groundwork for our entire application: a secure and segmented network.

## 🎯 What You'll Achieve

By the end of this module, you will have deployed a secure, custom VPC with isolated subnets for each application tier, enforced by strict firewall rules. This is the bedrock of our entire security posture.

**Your Deliverables:**
- A custom-mode Virtual Private Cloud (VPC) to house our application
- Three logically isolated subnets: `web-subnet`, `app-subnet`, and `data-subnet`
- A set of firewall rules that implement a "least privilege" access model

## 🛡️ The 'Why' Behind the 'What': Core Security Principles

Before we write any code, let's understand the why. These are fundamental concepts in cloud security.

### Network Segmentation
Think of our VPC as a submarine. If one compartment gets breached (flooded), the sealed bulkheads prevent the entire vessel from sinking. Our subnets are these bulkheads. By placing our web, app, and database servers in separate subnets, we contain potential attacks and prevent an attacker from easily moving from a compromised web server directly to our sensitive database.

### Least Privilege Networking
We're abandoning the default "allow anything" approach. The principle of least privilege means a resource should only have the exact permissions it needs to do its job, and nothing more. Our firewall rules will be surgical, only allowing specific traffic (e.g., HTTPS) from specific sources (e.g., the internet) to specific destinations (e.g., our web servers). Everything else is denied by default.

### Defense in Depth
This module creates the first and arguably most important layer in our security "onion." A strong network perimeter is our outer wall. In later modules, we'll add more layers of security—like identity controls, data encryption, and instance hardening—but it all starts here.

## 🏗️ Our Blueprint: Target Architecture

This is the architecture we are building in this module. The firewall rules you'll create will enforce the traffic flows shown by the arrows.

```
          Internet
             |
    [allow-http/s] & [allow-ssh]
             |
    +─────────────────────────────────+
    │  VPC: my-app-vpc                │
    │                                 │
    │  ┌───────────┐                  │
    │  │web-subnet │ [web-server tag] │
    │  │10.0.1.0/24│◄─────────────────┤
    │  └─────┬─────┘                  │
    │        │ [allow-web-to-app:3000]│
    │  ┌─────▼─────┐                  │
    │  │app-subnet │ [app-server tag] │
    │  │10.0.2.0/24│◄─────────────────┤
    │  └─────┬─────┘                  │
    │        │ [allow-app-to-db:5432] │
    │  ┌─────▼─────┐                  │
    │  │data-subnet│[db-server tag]   │
    │  │10.0.3.0/24│                  │
    │  └───────────┘                  │
    │                                 │
    +─────────────────────────────────+
```

## 🚀 Let's Build: Hands-On Lab

We will be using Terraform to define our infrastructure as code (IaC). This is a best practice for creating repeatable, version-controlled, and secure environments.

Create a file named `main.tf` and add the following code blocks.

### Step 1: Create the VPC Network

This resource creates our custom VPC, which acts as a container for all our network resources. We set `auto_create_subnetworks` to `false` so we can define our subnets deliberately.

```hcl
# main.tf

# Create the custom VPC
resource "google_compute_network" "my_app_vpc" {
  name                    = "my-app-vpc"
  auto_create_subnetworks = false
}
```

### Step 2: Create the Tiered Subnets

Now, we define our three isolated "bulkheads" inside the VPC. Each subnet is assigned a unique IP range.

```hcl
# Add to main.tf

# Create the Web Tier Subnet
resource "google_compute_subnetwork" "web_subnet" {
  name          = "web-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-central1"
  network       = google_compute_network.my_app_vpc.id
}

# Create the App Tier Subnet
resource "google_compute_subnetwork" "app_subnet" {
  name          = "app-subnet"
  ip_cidr_range = "10.0.2.0/24"
  region        = "us-central1"
  network       = google_compute_network.my_app_vpc.id
}

# Create the Data Tier Subnet
resource "google_compute_subnetwork" "data_subnet" {
  name          = "data-subnet"
  ip_cidr_range = "10.0.3.0/24"
  region        = "us-central1"
  network       = google_compute_network.my_app_vpc.id
}
```

### Step 3: Implement the Firewall Rules

This is where we enforce our security policy. Notice how each rule is specific about the network, traffic direction, source, destination (via tags), and protocol/port.

```hcl
# Add to main.tf

# Allow public HTTP/HTTPS traffic to the web tier
resource "google_compute_firewall" "allow_http_https_web" {
  name    = "allow-http-https-web"
  network = google_compute_network.my_app_vpc.name
  
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
  
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web-server"]
}

# Allow SSH for management to the web tier (can be restricted further in a real environment)
resource "google_compute_firewall" "allow_ssh_web" {
  name    = "allow-ssh-web"
  network = google_compute_network.my_app_vpc.name
  
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web-server"]
}

# Allow traffic from the Web Tier to the App Tier on the application port
resource "google_compute_firewall" "allow_web_to_app" {
  name    = "allow-web-to-app"
  network = google_compute_network.my_app_vpc.name
  
  allow {
    protocol = "tcp"
    ports    = ["3000"]
  }
  
  source_tags = ["web-server"]
  target_tags = ["app-server"]
}

# Allow traffic from the App Tier to the Data Tier on the database port
resource "google_compute_firewall" "allow_app_to_db" {
  name    = "allow-app-to-db"
  network = google_compute_network.my_app_vpc.name
  
  allow {
    protocol = "tcp"
    ports    = ["5432"]
  }
  
  source_tags = ["app-server"]
  target_tags = ["db-server"]
}
```

### Deploy the Infrastructure

Now, run the standard Terraform commands in your terminal to bring your network to life:

```bash
# Initialize Terraform
terraform init

# Review the planned changes
terraform plan

# Apply the changes
terraform apply
```

## ✔️ Verify Your Work

After `terraform apply` completes successfully, it's crucial to verify the resources in the GCP console.

**Check the VPC:** In the GCP Console, navigate to VPC network → VPC networks. Do you see `my-app-vpc` listed?

**Check the Subnets:** Click on `my-app-vpc`. Do you see the three subnets (`web-subnet`, `app-subnet`, `data-subnet`) listed with their correct IP CIDR ranges (`10.0.1.0/24`, etc.)?

**Check the Firewall Rules:** In the left menu, navigate to Firewall. In the filter bar, filter by Network: `my-app-vpc`.

- Do you see all four rules you created?
- Click on `allow-web-to-app`. Does it correctly show `web-server` as the Source tags and `app-server` as the Target tags?
- Click on `allow-http-https-web`. Does it correctly show `0.0.0.0/0` as the Source IPv4 ranges?

## 💥 What This Prevents

By implementing this architecture, you have already mitigated one of the most common attack paths: **uncontrolled lateral movement**. If a vulnerability were discovered in a web server (the most exposed part of our app), an attacker would not be able to directly scan or connect to the database. They are in a different "watertight compartment," and the firewall rules we created act as the locked hatch between them.

## Next Up...

Fantastic work! You've built a solid and secure network foundation. In the next module, we'll start deploying workloads and tackle the next critical security layer: **Identity and Access Management (IAM)**
