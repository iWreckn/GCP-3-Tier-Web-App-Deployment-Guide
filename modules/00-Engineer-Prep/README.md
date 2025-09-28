# 🚀 Module 00: Preparing the Battlefield - Engineer Prep Work

Welcome to the **GCP 3-Tier Security Training Lab!** This isn't just another cloud tutorial - this is your pathway to building **production-grade DevSecOps skills** that get you hired in 2025. Before we write a single line of infrastructure code, we need to establish a rock-solid foundation that prevents headaches, protects your wallet, and builds your professional portfolio.

Think of this module as your **mission briefing and equipment check**: gather your tools, secure the operational area, establish credentials, and prepare for building in public.

## 🎯 Learning Objectives

By completing this module, you will have:

- **Professional Development Environment**: All industry-standard tools installed and configured
- **Secure GCP Project**: Properly configured with billing protection and monitoring
- **Financial Safety Net**: Multiple layers of cost protection and emergency procedures
- **Professional GitHub Portfolio**: Repository configured for career development
- **Production Mindset**: Understanding of enterprise workflows and best practices
- **Troubleshooting Foundation**: Systematic approach to diagnosing and resolving issues

## 🧠 The "Why" Behind This Setup

### **Production Mindset from Day One**

Real DevSecOps engineers don't just copy code - they understand systems, manage costs, document decisions, and build with security and reliability in mind. This lab teaches you to think like a professional from the very first command.

### **Your GitHub is Your New Resume**

In 2025, hiring managers look at your GitHub before your resume. This project will become a showcase of your ability to build secure, well-documented infrastructure. Every commit is a demonstration of your professional growth.

### **Financial Responsibility**

Cloud costs can spiral quickly. We'll implement multiple safety nets so you can learn confidently without billing surprises. Understanding cost management is a critical DevSecOps skill.

### **Learning by Building Real Infrastructure**

You'll deploy actual GCP resources, not toy examples. This hands-on approach builds muscle memory and confidence that translates directly to professional environments.

## 🛡️ Financial Safety First

Before we touch any cloud resources, let's establish your financial safety net. **This is non-negotiable.**

### **Understanding GCP Costs**

**What's Free:**
- Google account creation and basic GCP Console access
- $300 free trial credits (valid for 90 days)
- Always Free tier for specific resource limits
- This tutorial's resources should stay within free tier limits

**What Costs Money:**
- Resources beyond Always Free tier limits
- Premium services like Cloud SQL (used in later modules)
- Data transfer and storage beyond free quotas
- Compute instances running 24/7

**Estimated Tutorial Costs:**
- **Modules 1-2**: $0 (within Always Free tier)
- **Complete Tutorial**: $10-25 total if you clean up resources promptly
- **If Left Running**: $50-100+ per month

### **Setting Up Billing Protection**

We'll configure multiple layers of protection:

1. **Billing Account with Spending Limits**
2. **Budget Alerts at Multiple Thresholds**
3. **Project-Level Monitoring**
4. **Emergency Shutdown Procedures**

## 🔧 Part 1: Your Professional Toolkit

These tools are industry standard for DevSecOps professionals. Installing them properly is your first professional skill demonstration.

### **Essential Tools Checklist**

#### **Terraform CLI** - Infrastructure as Code Foundation
**Purpose**: Define and manage cloud infrastructure with code instead of clicking through consoles.

**Installation:**
- **Windows**: Download from [HashiCorp Terraform Releases](https://releases.hashicorp.com/terraform/)
- **macOS**: `brew install terraform`
- **Linux**: Use package manager or download binary

**Verification**: Run `terraform version` - you should see version 1.0 or higher.

**Why This Matters**: Terraform is the industry standard for infrastructure as code. Mastering it is essential for any cloud role.

#### **Google Cloud SDK (gcloud CLI)** - GCP Command Line Interface
**Purpose**: Interact with GCP services from your terminal and authenticate Terraform.

**Installation:**
- **All Platforms**: Follow [Google Cloud SDK Installation Guide](https://cloud.google.com/sdk/docs/install)
- **Alternative**: Use Google Cloud Shell (browser-based, pre-installed)

**Verification**: Run `gcloud version` - you should see the SDK version and components.

**Why This Matters**: Command-line proficiency is expected in DevSecOps roles. GUI clicking doesn't scale.

#### **Git** - Version Control System
**Purpose**: Track changes, collaborate with teams, and maintain professional code history.

**Installation:**
- **Windows**: [Git for Windows](https://git-scm.com/download/win)
- **macOS**: `brew install git` or Xcode Command Line Tools
- **Linux**: Use package manager (`apt install git`, `yum install git`)

**Verification**: Run `git --version`

**Configuration** (Replace with your professional information):
```bash
git config --global user.name "Your Professional Name"
git config --global user.email "your.professional@email.com"
```

**Why This Matters**: Git is fundamental to all software development. Your commit history demonstrates your professional growth.

#### **Code Editor** - Development Environment
**Recommended**: **Visual Studio Code** with extensions

**Installation**: Download from [VS Code Official Site](https://code.visualstudio.com/)

**Essential Extensions**:
- **HashiCorp Terraform**: Syntax highlighting and validation
- **GitLens**: Enhanced Git integration
- **Cloud Code**: GCP integration and debugging

**Alternative Editors**: IntelliJ IDEA, Vim, Emacs (if you have preferences)

**Why This Matters**: Professional developers use proper IDEs with syntax highlighting, error detection, and integrated debugging.

### **Installation Troubleshooting**

#### **Common Issues and Solutions**

**PATH Problems (Tool not found after installation)**:
- **Windows**: Add installation directory to System PATH via Environment Variables
- **macOS/Linux**: Add to `~/.bashrc`, `~/.zshrc`, or equivalent shell config
- **Verification**: Open new terminal and test commands

**Permission Errors**:
- **Windows**: Run installer as Administrator
- **macOS/Linux**: Use `sudo` for system-wide installation or install to user directory
- **Corporate Networks**: May need IT assistance for firewall/proxy configuration

**Version Conflicts**:
- Use version managers like `tfenv` for Terraform or `gcloud components update`
- Uninstall old versions before installing new ones
- Check for conflicting installations in different directories

**Corporate Network Issues**:
- Configure proxy settings for tools if behind corporate firewall
- May need to use alternative installation methods (offline installers)
- Contact IT for whitelist requests if downloads are blocked

## ☁️ Part 2: GCP Environment Setup - The Foundation

### **Step 1: Google Account Preparation**

**If You Don't Have a Google Account:**
1. Create account at [accounts.google.com](https://accounts.google.com)
2. Use a professional email address if possible
3. **Enable 2-Factor Authentication** (Security → 2-Step Verification)
4. **Set up Account Recovery** (add phone number and recovery email)

**Security Best Practices:**
- Use a strong, unique password (password manager recommended)
- Enable 2FA with authenticator app (Google Authenticator, Authy)
- Review account permissions regularly

### **Step 2: GCP Account and Project Creation**

**Activate GCP Account:**
1. Navigate to [Google Cloud Console](https://console.cloud.google.com)
2. Accept terms of service
3. **Verify Identity** (may require phone verification)
4. **Claim $300 Free Trial Credits** (requires valid credit card for verification)

**Create Your Project:**
1. Click "Select a Project" → "New Project"
2. **Project Name**: Use descriptive, professional naming
   - Good: `gcp-security-lab-yourname`
   - Bad: `test123` or `my-project`
3. **Project ID**: Will be auto-generated (note this for later use)
4. **Organization**: Leave as "No organization" for personal projects

**Why Professional Naming Matters**: Project names appear in billing, logs, and resource URLs. Professional naming demonstrates attention to detail.

### **Step 3: Billing Account Setup and Protection**

**Create Billing Account:**
1. Navigate to **Billing** in GCP Console
2. **Create Billing Account**
3. **Add Payment Method** (required even for free tier)
4. **Link to Your Project**

**Critical: Set Up Spending Protection**

**Budget Alerts (Multiple Thresholds):**
1. Go to **Billing** → **Budgets & Alerts**
2. **Create Budget**
3. **Configure Alerts**:
   - **$5 Alert**: 50% of expected tutorial cost
   - **$15 Alert**: 150% of expected tutorial cost  
   - **$50 Alert**: Emergency threshold
4. **Alert Recipients**: Add your email address
5. **Enable**: "Connect a Pub/Sub topic" for programmatic alerts (optional but recommended)

**Spending Limits (If Available):**
- Some account types allow hard spending limits
- Configure if available in your billing account

**Daily Monitoring Setup:**
1. **Billing Dashboard**: Bookmark for daily checks
2. **Cost Breakdown**: Monitor by service and project
3. **Usage Reports**: Track resource consumption patterns

### **Step 4: API Enablement and Authentication**

**Enable Required APIs:**
```bash
# Set your project (replace YOUR_PROJECT_ID)
gcloud config set project YOUR_PROJECT_ID

# Enable essential APIs
gcloud services enable compute.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable iam.googleapis.com
gcloud services enable cloudbilling.googleapis.com
```

**Authenticate Your Local Environment:**
```bash
# Authenticate gcloud CLI
gcloud auth login

# Set up Application Default Credentials for Terraform
gcloud auth application-default login
```

**Verify Authentication:**
```bash
# Test gcloud access
gcloud projects list

# Test authentication
gcloud auth list
```

**Troubleshooting Authentication:**
- **Browser Issues**: Use `gcloud auth login --no-launch-browser` for headless environments
- **Corporate Networks**: May need proxy configuration
- **Permission Errors**: Ensure you have Owner or Editor role on the project

### **Step 5: Remote State Backend (Professional Infrastructure Management)**

**Why Remote State Matters:**
- **Collaboration**: Multiple team members can work on same infrastructure
- **State Locking**: Prevents concurrent modifications that could corrupt infrastructure
- **Backup**: State is safely stored in cloud, not just on your laptop
- **Audit Trail**: Changes are tracked and versioned

**Create GCS Bucket for Terraform State:**
```bash
# Create globally unique bucket name (replace with your unique identifier)
export BUCKET_NAME="terraform-state-$(whoami)-$(date +%Y%m%d)"

# Create the bucket
gsutil mb -p YOUR_PROJECT_ID -l us-central1 gs://${BUCKET_NAME}/

# Enable versioning for state backup
gsutil versioning set on gs://${BUCKET_NAME}/

# Verify bucket creation
gsutil ls -p YOUR_PROJECT_ID
```

**Security Note**: This bucket will contain sensitive infrastructure state. Never make it publicly accessible.

## 📂 Part 3: Professional Project Structure

**Create Your Local Project Directory:**
```bash
# Create project directory
mkdir gcp-security-lab
cd gcp-security-lab

# Initialize Git repository
git init

# Create professional directory structure
mkdir -p {environments/dev,modules/{00-setup,01-network-security,02-iam-security}}
mkdir -p docs/{troubleshooting,security-theory}

# Create essential files
touch README.md .gitignore
touch environments/dev/{backend.tf,main.tf,terraform.tfvars,versions.tf}
```

**Professional .gitignore:**
```gitignore
# Terraform
*.tfstate
*.tfstate.*
*.tfvars
.terraform/
.terraform.lock.hcl
crash.log

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Credentials
*.json
*.pem
*.key
```

**Why This Structure Matters:**
- **Environments Directory**: Separates dev/staging/prod configurations
- **Modules Directory**: Reusable infrastructure components
- **Documentation**: Professional projects are well-documented
- **Git Ignore**: Prevents sensitive data from being committed

## 🔐 Part 4: GitHub Portfolio Setup

### **Professional GitHub Repository**

**Create Repository:**
1. Go to [GitHub.com](https://github.com) and sign in/create account
2. **Repository Name**: `gcp-security-training-lab`
3. **Description**: "Production-grade GCP security implementation with Terraform - demonstrating DevSecOps best practices"
4. **Public Repository**: Make it public for portfolio visibility
5. **Initialize with README**: Uncheck (we'll create our own)

**Professional README Template:**
```markdown
# GCP Security Training Lab

## Overview
Production-grade implementation of a secure 3-tier web application on Google Cloud Platform, demonstrating enterprise security best practices and DevSecOps workflows.

## Architecture
[Architecture diagram will go here]

## Modules
- **Module 00**: Environment setup and tooling
- **Module 01**: Network security and segmentation  
- **Module 02**: Identity and access management
- [Additional modules as implemented]

## Skills Demonstrated
- Infrastructure as Code with Terraform
- GCP security best practices
- Network segmentation and firewall management
- Identity and access management (IAM)
- Cost management and monitoring
- Professional documentation and version control

## Getting Started
[Link to Module 00 setup instructions]

## Learning Outcomes
This project demonstrates proficiency in cloud security engineering, infrastructure automation, and enterprise DevSecOps practices.
```

**Connect Local Repository to GitHub:**
```bash
# Add remote origin (replace with your GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/gcp-security-training-lab.git

# Create initial commit
git add .
git commit -m "Initial project structure and documentation"

# Push to GitHub
git branch -M main
git push -u origin main
```

### **Professional Commit Practices**

**Commit Message Standards:**
```bash
# Good commit messages
git commit -m "feat: implement VPC network security module"
git commit -m "docs: add troubleshooting guide for authentication issues"
git commit -m "fix: resolve firewall rule priority conflicts"

# Bad commit messages (avoid these)
git commit -m "stuff"
git commit -m "fixed it"
git commit -m "updates"
```

**Why This Matters**: Professional commit history demonstrates your ability to work in team environments and maintain clean code history.

## 🚨 Part 5: Emergency Procedures and Cost Management

### **Daily Monitoring Routine**

**Every Day You're Working on This Lab:**
1. **Check Billing Dashboard**: Look for unexpected charges
2. **Review Resource Usage**: Ensure resources are being cleaned up
3. **Monitor Budget Alerts**: Respond immediately to any alerts

### **Emergency Shutdown Procedures**

**If You See Unexpected Charges:**

**Immediate Actions:**
```bash
# List all compute instances
gcloud compute instances list --format="table(name,zone,status)"

# Stop all running instances
gcloud compute instances stop INSTANCE_NAME --zone=ZONE_NAME

# List all other billable resources
gcloud sql instances list
gcloud container clusters list
gcloud compute disks list
```

**Nuclear Option (Complete Project Shutdown):**
1. **GCP Console** → **IAM & Admin** → **Settings**
2. **Shut Down Project** (this is irreversible)
3. **Confirm Shutdown** (all resources will be deleted)

**Prevention is Better Than Cure:**
- Always run `terraform destroy` when finished with modules
- Never leave resources running overnight unless necessary
- Set calendar reminders to check your project

### **Resource Cleanup Checklist**

**After Each Module:**
- [ ] Run `terraform destroy` to remove all resources
- [ ] Verify in GCP Console that resources are deleted
- [ ] Check billing dashboard for any ongoing charges
- [ ] Commit your code changes to GitHub

**Weekly Cleanup:**
- [ ] Review all projects in your GCP account
- [ ] Delete any test projects you're not actively using
- [ ] Review billing account for any unexpected charges

## ✅ Module 00 Completion Checklist

### **Tools and Environment**
- [ ] Terraform installed and `terraform version` works
- [ ] gcloud CLI installed and `gcloud version` works  
- [ ] Git installed and configured with professional identity
- [ ] VS Code installed with Terraform extension
- [ ] All tools accessible from new terminal sessions

### **GCP Project Setup**
- [ ] Google account created with 2FA enabled
- [ ] GCP project created with professional naming
- [ ] Billing account linked with valid payment method
- [ ] Budget alerts configured at $5, $15, and $50 thresholds
- [ ] Required APIs enabled (compute, cloudresourcemanager, iam)
- [ ] Authentication working (`gcloud projects list` succeeds)

### **Professional Infrastructure**
- [ ] GCS bucket created for Terraform state with versioning enabled
- [ ] Local project directory created with professional structure
- [ ] GitHub repository created and linked to local project
- [ ] Professional README.md created and committed
- [ ] .gitignore configured to protect sensitive files

### **Safety and Monitoring**
- [ ] Billing dashboard bookmarked and accessible
- [ ] Emergency shutdown procedures documented and understood
- [ ] Daily monitoring routine established
- [ ] Resource cleanup procedures tested

### **Knowledge Verification**
- [ ] Understand why we use Infrastructure as Code
- [ ] Can explain the purpose of remote state storage
- [ ] Know how to monitor and control GCP costs
- [ ] Understand professional Git workflow and commit practices
- [ ] Ready to build infrastructure that demonstrates professional skills
- [ ] 
## 🚀 What's Next?

**Module 01: Network Security** awaits! You'll use everything configured in this module to build a secure, segmented network architecture that forms the foundation of enterprise cloud security.

**Remember**: This isn't just a tutorial - it's your demonstration of professional cloud engineering skills. Every decision, every commit, and every resource you create is building your reputation as a skilled DevSecOps professional.

## 📚 Additional Resources

### **Essential Reading**
- [Google Cloud Free Tier](https://cloud.google.com/free) - Understanding what's always free
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/index.html) - Professional Terraform workflows
- [Git Best Practices](https://git-scm.com/book/en/v2) - Professional version control

### **Professional Development**
- [Google Cloud Certifications](https://cloud.google.com/certification) - Career advancement paths
- [DevSecOps Roadmap](https://roadmap.sh/devops) - Skills development guide
- [Cloud Security Alliance](https://cloudsecurityalliance.org/) - Industry standards and best practices

### **Community and Support**
- [Google Cloud Community](https://cloud.google.com/community) - Official community resources
- [r/googlecloud](https://reddit.com/r/googlecloud) - Community discussions and troubleshooting
- [Stack Overflow](https://stackoverflow.com/questions/tagged/google-cloud-platform) - Technical Q&A
---
**🔐 Remember: In DevSecOps, security isn't an afterthought - it's built into every decision from day one. This foundation module establishes that mindset and the tools to implement it professionally.**
