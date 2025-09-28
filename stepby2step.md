# 🚀 Module 00: Preparing the Battlefield - Engineer Prep Work

Welcome to the **GCP 3-Tier App Deployment Guide!** Before we write a single line of infrastructure code, we need to set up our local machine and our Google Cloud environment. This initial setup is the foundation for everything that follows. A solid foundation prevents a world of headaches later on.

Think of this module as your **mission briefing**: gather your tools, prep the operational area, and establish credentials.

---

## 🎯 Objectives

* Install all necessary command-line tools
* Configure a dedicated GCP project for this tutorial
* Enable the required cloud APIs
* Create a secure, remote backend for Terraform state
* Authenticate to GCP from your local machine
* Create a professional, modular directory structure for our project

---

## 🛠 Part 1: The Engineer's Toolkit (Local Machine Setup)

These are the essential tools you'll need installed:

* ✅ **Terraform CLI** – The core tool for defining and managing infrastructure as code.
  **How:** [HashiCorp Install Guide](https://learn.hashicorp.com/terraform)

* ✅ **Google Cloud SDK (gcloud CLI)** – CLI for interacting with your GCP account.
  **How:** [Google Cloud SDK Install Guide](https://cloud.google.com/sdk/docs/install)

* ✅ **Git** – Industry-standard version control.
  **How:** Install Git for your OS.

* ✅ **Code Editor** – Recommended: **Visual Studio Code**

  * [VS Code Download](https://code.visualstudio.com/)
  * **Extension:** HashiCorp Terraform extension for syntax highlighting & autocompletion

---

## ☁️ Part 2: GCP Environment Setup (The Cloud Foundation)

Prep your cloud environment (via GCP Console or gcloud CLI):

* ✅ **Create a GCP Project**

  * Example name: `gcp-3tier-app-lab`
  * **Important:** Enable billing

* ✅ **Set the project in CLI**

```bash
gcloud config set project YOUR_PROJECT_ID
```

* ✅ **Enable Required APIs**

```bash
gcloud services enable compute.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
```

* ✅ **Create GCS Bucket for Terraform State**

```bash
gsutil mb -p YOUR_PROJECT_ID -l us-central1 gs://your-unique-bucket-name/
gsutil versioning set on gs://your-unique-bucket-name/
```

> ⚠️ Replace `your-unique-bucket-name` with a globally unique name.

---

## 🔑 Part 3: Authentication (Getting the Keys)

Authenticate Terraform to your GCP project:

```bash
gcloud auth application-default login
```

This opens a browser, logs you in, and saves credentials locally.

---

## 📂 Part 4: Create the Project Structure

A modular layout is key for maintainable IaC:

```
gcp-3-tier-app-tutorial/
├── environments/
│   └── dev/
│       ├── backend.tf       # Configures remote state
│       ├── main.tf          # Dev environment blueprint
│       ├── terraform.tfvars # Dev-specific values
│       └── versions.tf      # Pins Terraform & provider versions
└── modules/
    ├── 00-setup/
    │   └── README.md        # This file!
    └── 01-network-security/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

* ✅ **Populate Initial Files**
  Fill `backend.tf`, `versions.tf`, `main.tf`, and `terraform.tfvars` with the starter code. Update bucket names and project IDs as necessary.

---

## 🏁 Mission Prep Complete!

You are now fully set up and ready to begin building. Your tools are installed, your cloud environment is prepped, and your project structure is professional.

Next up: **Module 01 - Network Security**, where we'll deploy our secure VPC foundation.

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
# Terraform Variables: Hard-Coded vs Variable-Based Configuration

This guide explains the difference between hard-coded values and variables in Terraform, using our 3-tier GCP network infrastructure as an example.

## Hard-Coded Configuration (Not Recommended for Production)

In a hard-coded configuration, all values are directly written into the Terraform files:


resource "google_compute_network" "my_app_vpc" {
  name                    = "my-3tier-app-vpc"
  auto_create_subnetworks = false
  project                 = "your-project-id-here"
}

resource "google_compute_subnetwork" "web_subnet" {
  name          = "test-web-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-central1"
  network       = google_compute_network.my_app_vpc.id
  project       = "your-project-id-here"
}


### Problems with Hard-Coded Values:
- **Not reusable**: You need separate files for different environments
- **Error-prone**: Easy to forget to change values when copying between environments
- **Maintenance nightmare**: Changes require editing multiple files
- **Security risk**: Sensitive values are exposed in code

## Variable-Based Configuration (Recommended)

Variables make your Terraform code flexible and reusable:


resource "google_compute_network" "my_app_vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
  project                 = var.project_id
}

resource "google_compute_subnetwork" "web_subnet" {
  name          = "${var.environment}-web-subnet"
  ip_cidr_range = var.web_subnet_cidr
  region        = var.region
  network       = google_compute_network.my_app_vpc.id
  project       = var.project_id
}


## How Terraform Variables Work

### 1. Define Variables (`variables.tf`)


variable "project_id" {
  description = "The Google Cloud Project ID"
  type        = string
}

variable "environment" {
  description = "Environment name (test, prod, dev)"
  type        = string
  validation {
    condition     = contains(["test", "prod", "dev"], var.environment)
    error_message = "Environment must be test, prod, or dev."
  }
}

variable "region" {
  description = "The GCP region to deploy resources"
  type        = string
  default     = "us-central1"
}


### 2. Provide Values (`terraform.tfvars`)

project_id = "my-actual-project-id"
environment = "test"
region = "us-central1"
vpc_name = "my-3tier-app-vpc"


### 3. Use Variables in Configuration (`main.tf`)


resource "google_compute_subnetwork" "web_subnet" {
  name          = "${var.environment}-web-subnet"
  ip_cidr_range = var.web_subnet_cidr
  region        = var.region
  network       = google_compute_network.my_app_vpc.id
  project       = var.project_id
}


## Variable Types

| Type | Example | Description |
|------|---------|-------------|
| `string` | `"us-central1"` | Text values |
| `number` | `1000` | Numeric values |
| `bool` | `true` or `false` | Boolean values |
| `list(string)` | `["web-server", "app-server"]` | List of strings |
| `map(string)` | `{ env = "test", owner = "team" }` | Key-value pairs |

## Variable Features

### Default Values
Variables can have default values, making them optional:


variable "region" {
  description = "The GCP region to deploy resources"
  type        = string
  default     = "us-central1"  # Optional - will use this if not provided
}


### Validation Rules
Add validation to ensure variables meet requirements:


variable "environment" {
  description = "Environment name"
  type        = string
  validation {
    condition     = contains(["test", "prod", "dev"], var.environment)
    error_message = "Environment must be test, prod, or dev."
  }
}

## Benefits of Using Variables

1. **Reusability**: Same code works for multiple environments
2. **Consistency**: Reduces human error when deploying
3. **Security**: Sensitive values can be passed securely
4. **Maintainability**: Changes in one place affect all resources
5. **Documentation**: Variable descriptions explain what each value does

## Directory Structure Best Practice

```
project/
├── environments/
│   ├── test/
│   │   ├── terraform.tfvars  # Test environment values
│   │   └── main.tf           # Calls modules with variables
│   └── prod/
│       ├── terraform.tfvars  # Production environment values
│       └── main.tf           # Same code, different values
└── modules/
    └── network/
        ├── main.tf           # Resource definitions with variables
        ├── variables.tf      # Variable declarations
        └── outputs.tf        # Output declarations
```

## How to Use This Project

1. **For Learning**: Compare the hard-coded version with the variable version
2. **For Development**: Use the `test/` environment with your values
3. **For Production**: Copy to `prod/` environment with production values

## Common Variable Patterns

### Environment-Based Naming

name = "${var.environment}-${var.resource_name}"
# Results in: "test-web-subnet" or "prod-web-subnet"


### Conditional Values

instance_count = var.environment == "prod" ? 3 : 1
# 3 instances for prod, 1 for everything else


### Environment-Specific Maps

variable "instance_types" {
  type = map(string)
  default = {
    test = "e2-micro"
    prod = "e2-standard-2"
  }
}

instance_type = var.instance_types[var.environment]


## Next Steps

1. Start with hard-coded values to understand the resources
2. Identify values that change between environments
3. Extract those values into variables
4. Add validation rules for important variables
5. Create separate `.tfvars` files for each environment

Remember: Variables make your Terraform code more professional, maintainable, and less error-prone!

Fantastic work! You've built a solid and secure network foundation. In the next module, we'll start deploying workloads and tackle the next critical security layer: **Identity and Access Management (IAM)**
