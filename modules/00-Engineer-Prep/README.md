Module 00: Preparing the Battlefield - Engineer Prep work!

Welcome to the GCP 3-Tier App Deployment Guide! Before we write a single line of infrastructure code, we need to set up our local machine and our Google Cloud environment. This initial setup is the foundation for everything that follows. A solid foundation prevents a world of headaches later on.

Think of this module as your mission briefing. We'll gather our tools, prep the operational area, and establish our credentials.

🎯 Your Objectives
Install all necessary command-line tools.

Configure a dedicated GCP project for this tutorial.

Enable the required cloud APIs.

Create a secure, remote backend for our Terraform state.

Authenticate to GCP from your local machine.

Create the professional, modular directory structure for our project.

Part 1: The Engineer's Toolkit (Local Machine Setup)
These are the essential tools you'll need installed on your computer.

✅ Terraform CLI: The core tool for defining and managing our infrastructure as code.

How: Follow the official HashiCorp Install Guide. We won't cover the installation steps here, as the official guide is the best source.

✅ Google Cloud SDK (gcloud CLI): The command-line interface for interacting with your GCP account. We'll use this for authentication and project setup.

How: Follow the official Google Cloud SDK Install Guide.

✅ Git: The industry-standard version control system. Essential for managing our codebase.

How: Install Git for your operating system.

✅ A Code Editor: You'll need a good editor for writing code. We highly recommend Visual Studio Code.

How: Download VS Code.

Recommended Extension: Install the official HashiCorp Terraform extension for syntax highlighting and autocompletion.

Part 2: GCP Environment Setup (The Cloud Foundation)
Now, let's prep our cloud environment. All of these steps are performed in the GCP Console or using the gcloud CLI you just installed.

✅ Create a GCP Project: All of your resources will live inside a dedicated project.

Go to the GCP Console and create a new project. Give it a unique name (e.g., gcp-3tier-app-lab).

Important: Make sure you enable billing for this project.

✅ Set Your Project in the CLI: Tell gcloud which project you want to work with. Replace YOUR_PROJECT_ID with the ID of the project you just created.

gcloud config set project YOUR_PROJECT_ID

✅ Enable Required APIs: Terraform needs certain GCP APIs to be enabled before it can create resources. Let's enable the ones we'll need for networking and project management.

gcloud services enable compute.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com

✅ Create the GCS Bucket for Terraform State: As a best practice, we will store our Terraform state file remotely in a Google Cloud Storage bucket. This is critical for security and collaboration.

Choose a globally unique name for your bucket. We recommend using your project ID to ensure it's unique.

Replace your-unique-bucket-name with your chosen name.

gsutil mb -p YOUR_PROJECT_ID -l us-central1 gs://your-unique-bucket-name/

Enable versioning on the bucket as a safety measure. This keeps a history of your state files, allowing you to recover from mistakes.

gsutil versioning set on gs://your-unique-bucket-name/

Part 3: Authentication (Getting the Keys)
Now we need to securely connect your local machine (running Terraform) to your GCP project. We'll use Application Default Credentials (ADC), which is a secure and easy method for local development.

✅ Log in with ADC: This command will open a browser window, ask you to log in to your Google account, and grant the gcloud CLI access. These credentials will then be automatically picked up by Terraform.

gcloud auth application-default login

Part 4: Create the Project Structure
Finally, let's create the directory structure we've discussed. This modular layout is key to building a scalable and maintainable IaC project.

✅ Create the following folders and files: Your project should look like this.

gcp-3-tier-app-tutorial/
|
├── 📂 environments/
│   └── 📂 dev/
│       ├── 📜 backend.tf       # Configures remote state
│       ├── 📜 main.tf          # The "blueprint" for the dev environment
│       ├── 📜 terraform.tfvars # Dev-specific values (project_id, etc.)
│       └── 📜 versions.tf      # Pins Terraform and provider versions
│
└── 📂 modules/
    ├── 📂 00-setup/
    │   └── 📜 README.md        # This file!
    │
    └── 📂 01-network-security/
        ├── 📜 main.tf
        ├── 📜 variables.tf
        └── 📜 outputs.tf

✅ Populate Initial Files: Fill your backend.tf, versions.tf, main.tf, and terraform.tfvars with the code we generated in our conversation. Remember to edit the bucket name in backend.tf and the project ID in terraform.tfvars!

🚀 Mission Prep Complete!
You are now fully set up and ready to begin building. Your tools are installed, your cloud environment is prepped, and your project structure is clean and professional.

In the next module, we'll dive into 01-network-security and deploy our secure VPC foundation.