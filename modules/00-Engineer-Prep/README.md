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
