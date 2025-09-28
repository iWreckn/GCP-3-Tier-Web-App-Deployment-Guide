# 🔐 Module 3: Securing the Data Tier - Private Cloud SQL

Welcome to Module 3! Having secured our network (Module 1) and established strong identities (Module 2), we now focus on the heart of our application: the **data tier**. In this module, you will deploy a production-grade, secure Cloud SQL for PostgreSQL instance, ensuring our sensitive data is protected from both external and internal threats.

## 🎯 What You'll Achieve

By the end of this module, you will have a fully secured and private database tier, built on enterprise best practices.

**Your Deliverables:**

*   A **Cloud SQL for PostgreSQL** instance with no public IP address, completely isolated from the internet.
*   Automated, secure management of the database root password using **Secret Manager**.
*   A **Private Service Connection** linking your VPC to Google's underlying services, enabling secure, internal communication.
*   Enforced **SSL/TLS encryption** for all database connections.

## 🧠 The 'Why': Core Data Security Principles

Before we build, let's understand the critical security concepts that guide our design.

### Data Isolation

A database should never be directly exposed to the public internet. By disabling the public IP and using a private, internal IP address, we eliminate a massive attack surface. This forces all connections to originate from within our secure VPC, which is already protected by the firewall rules we created in Module 1.

### Credential Security

Hardcoding passwords in code or configuration files is one of the most common and dangerous security anti-patterns. We will use Google's Secret Manager to automatically generate and store our database's root password. Our infrastructure code will reference the secret, but the actual password value will never be exposed in plain text.

### Defense in Depth

This module adds several new layers to our security "onion":
1.  **Network Layer:** The database is only accessible from within the private VPC.
2.  **Identity Layer:** Only specific service accounts (which we'll configure later) will have permission to connect to the database.
3.  **Encryption Layer:** Data is encrypted at rest by default, and we will enforce encryption in transit (SSL/TLS).

## 🏗️ Our Blueprint: See-It-Then-Build-It

This lab follows a **see-it-then-build-it** methodology. First, we'll explore the GCP Console to understand the components visually. Then, we'll implement the exact same setup using Terraform for a repeatable, automated deployment.

## 🚀 Part 1: Understanding the Architecture (Console Exploration)

Before writing any code, let's get familiar with the GCP services we'll be using.

### Step 1: Explore Secret Manager (Password Security)

First, let's see how GCP securely stores sensitive data like database passwords.

1.  In the GCP Console, navigate to **Security** > **Secret Manager**.
2.  Click **Create Secret** to view the interface. Notice the fields for **Secret ID** and **Replication**. We will automate the creation of a secret to store our database password.

    `[Image placeholder: Screenshot of the "Create Secret" page in Secret Manager]`

### Step 2: Understand Private Services Access (Network Security)

Next, let's see how our VPC will connect to the Cloud SQL instance privately.

1.  Navigate to **VPC Network** > **VPC networks**.
2.  Click on the **default** network.
3.  Select the **PRIVATE SERVICE CONNECTION** tab. This is where a connection to Google's services will be established, allowing our VPC to communicate with Cloud SQL without using the public internet.

    `[Image placeholder: Screenshot of the "Private service connection" tab for the default VPC]`

### Step 3: Explore Cloud SQL Creation (Database Setup)

Finally, let's walk through the manual creation process to understand the settings our Terraform code will configure.

1.  Navigate to **Databases** > **SQL**.
2.  Click **Create Instance** and choose **PostgreSQL**.
3.  On the configuration page, observe the following critical settings:
    *   **Instance ID**: A unique name for our database.
    *   **Password**: We will automate this with a randomly generated password.
    *   **Connections**: Under this section, note the **Private IP** option. Selecting this requires a private service connection, which our Terraform code will set up.
    *   **Deletion protection**: A vital safety feature to prevent accidental data loss.

    `[Image placeholder: Screenshot of the Cloud SQL instance creation page, highlighting the "Connections" and "Deletion protection" settings]`

## 🚀 Part 2: Implementing with Terraform (Infrastructure as Code)

Now that we understand the components, let's build them with code. The `main.tf` file in this module contains all the necessary resources.

### Step 1: Initialize Terraform

First, navigate to the `module-3` directory in your terminal. Before you can apply the changes, you need to initialize Terraform. This command downloads the necessary providers, including the `random` provider for password generation.

```bash
terraform init
```

### Step 2: Review the Execution Plan

It's always a good practice to review the changes Terraform will make before applying them. Run the `plan` command:

```bash
terraform plan
```

You will see a list of resources that Terraform will create, including the `google_sql_database_instance`, `google_secret_manager_secret`, and networking resources.

### Step 3: Apply the Terraform Configuration

Now, apply the configuration to create the resources in your GCP project. You will be prompted to provide values for the variables defined in `variables.tf`.

```bash
terraform apply
```

Enter `yes` when prompted to confirm the action. Terraform will now provision your secure Cloud SQL instance. This process may take several minutes.

## ✅ Part 3: Verification and Learning Synthesis

After `terraform apply` completes successfully, let's verify the resources in the GCP Console.

### 1. Verify the Cloud SQL Instance

1.  Navigate back to **Databases** > **SQL**.
2.  You should now see your new instance, `my-app-db`, in the list.
3.  Click on the instance name to view its details.
4.  On the **Overview** page, confirm the following:
    *   There is **no Public IP address** listed.
    *   A **Private IP address** is assigned.
    *   Under the **Configuration** tab, verify that **Deletion protection** is enabled.

    `[Image placeholder: Screenshot of the Cloud SQL instance details page, showing the absence of a public IP and the presence of a private IP]`

### 2. Verify the Secret in Secret Manager

1.  Navigate to **Security** > **Secret Manager**.
2.  You will see a secret named `db-root-password`. This was created automatically by Terraform to securely store the root password for your database.

    `[Image placeholder: Screenshot of the Secret Manager page showing the newly created 'db-root-password' secret]`

### 3. Verify the Private Service Connection

1.  Navigate to **VPC Network** > **VPC networks** and click on the **default** network.
2.  Select the **PRIVATE SERVICE CONNECTION** tab. You will now see that a connection is active for **Service producer network** `servicenetworking.googleapis.com`.

    `[Image placeholder: Screenshot of the active Private Service Connection in the VPC details]`

## 📊 Security Architecture Summary

| Security Control | Implementation | Benefit |
| --- | --- | --- |
| **🔒 Data Isolation** | `ipv4_enabled = false` | Eliminates direct internet attack surface. |
| **🔑 Credential Security** | `random_password` + `google_secret_manager_secret` | Prevents hardcoded passwords and automates rotation. |
| **🔗 Private Connectivity** | `google_service_networking_connection` | Ensures database traffic never traverses the public internet. |
| **🛡️ Deletion Protection** | `deletion_protection = true` | Prevents accidental loss of a production database. |
| **🔐 Enforced Encryption** | `cloudsql.require_ssl = "on"` | Protects data from eavesdropping during transit. |

## 💥 What This Prevents

*   **Direct Database Attacks:** An attacker scanning the internet cannot find or connect to your database.
*   **Credential Leakage:** Your database password is not stored in your Git repository or local files, preventing a compromise if your code is leaked.
*   **Man-in-the-Middle Attacks:** Enforcing SSL ensures that even if an attacker could intercept traffic within your VPC, they could not read it.

## 📚 Additional Resources

*   📖 [Cloud SQL Private IP Documentation](https://cloud.google.com/sql/docs/postgres/configure-private-ip)
*   🔐 [Google Cloud Secret Manager](https://cloud.google.com/secret-manager)
*   🔗 [Private Services Access](https://cloud.google.com/vpc/docs/private-services-access)


# 🗄️ Module 3: Data Security - Protecting Your Most Valuable Asset

Welcome to Module 3! With our network perimeter secured (Module 1) and identities properly managed (Module 2), we now turn to the crown jewel of any application: **the data layer**. In this module, we'll implement enterprise-grade data protection that would make any CISO proud.

## 🎯 What You'll Achieve

By the end of this module, you will have deployed a production-ready data infrastructure that implements multiple layers of security controls:

**Your Deliverables:**
- **Secure Cloud SQL PostgreSQL Database** with private networking and encryption
- **Private Storage Bucket** for application files and backups
- **Secret Management** for secure credential storage
- **Database Access Controls** with least privilege principles
- **Monitoring and Alerting** for security events
- **Audit Logging** for compliance and forensics

## 🛡️ The 'Why' Behind Data Security: Core Principles

### **Data is the New Oil - And Just as Dangerous**

Your database contains the most sensitive information in your entire infrastructure: user data, financial records, personal information, and business secrets. A single data breach can destroy companies, violate regulations like GDPR, and ruin careers. This module treats data security with the gravity it deserves.

### **Defense in Depth for Data**

We're implementing multiple security layers:
- **Network Isolation**: Private subnets with no internet access
- **Encryption**: Data encrypted at rest and in transit
- **Access Controls**: Least privilege database users and IAM policies
- **Monitoring**: Real-time alerts for suspicious activity
- **Audit Trails**: Complete logging for compliance and forensics

### **Zero Trust Data Access**

Every connection to our database is authenticated, authorized, and audited. We assume breach and design accordingly - even if an attacker compromises other parts of our infrastructure, the data remains protected.

### **Compliance by Design**

This architecture meets requirements for major compliance frameworks including SOC 2, PCI DSS, HIPAA, and GDPR. We're not just securing data - we're building a foundation for enterprise compliance.

## 🏗️ Our Blueprint: Secure Data Architecture

```
    ┌─────────────────────────────────────────────────────────────┐
    │                    VPC: my-app-vpc                          │
    │                                                             │
    │  ┌─────────────┐    ┌─────────────┐    ┌─────────────────┐  │
    │  │ Web Subnet  │    │ App Subnet  │    │ DB Private      │  │
    │  │ 10.0.1.0/24 │    │ 10.0.2.0/24 │    │ Subnet          │  │
    │  │             │    │             │    │ 10.0.4.0/24     │  │
    │  │ [web-server]│    │ [app-server]│    │ [database]      │  │
    │  └─────────────┘    └─────────────┘    │ NO EXTERNAL IP  │  │
    │         │                   │          └─────────────────┘  │
    │         │                   │                   │           │
    │         └───────────────────┼───────────────────┘           │
    │                             │                               │
    │                    ┌────────▼────────┐                     │
    │                    │   Cloud SQL     │                     │
    │                    │   PostgreSQL    │                     │
    │                    │                 │                     │
    │                    │ ✓ Private IP    │                     │
    │                    │ ✓ Encrypted     │                     │
    │                    │ ✓ Backups       │                     │
    │                    │ ✓ Monitoring    │                     │
    │                    └─────────────────┘                     │
    └─────────────────────────────────────────────────────────────┘
    
    ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
    │ Cloud Storage   │    │ Secret Manager  │    │ Cloud Monitoring│
    │                 │    │                 │    │                 │
    │ ✓ Encrypted     │    │ ✓ DB Credentials│    │ ✓ DB Alerts     │
    │ ✓ Versioned     │    │ ✓ Conn Strings  │    │ ✓ Audit Logs    │
    │ ✓ IAM Protected │    │ ✓ Rotation      │    │ ✓ Compliance    │
    └─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 🚀 Step-by-Step Implementation

### **Prerequisites Check**

Before starting, ensure you have completed:
- ✅ **Module 1**: VPC and network security infrastructure
- ✅ **Module 2**: Service accounts and IAM policies
- ✅ **Required APIs**: Enable additional APIs for this module

```bash
# Enable required APIs for data services
gcloud services enable sqladmin.googleapis.com
gcloud services enable secretmanager.googleapis.com
gcloud services enable servicenetworking.googleapis.com
gcloud services enable monitoring.googleapis.com
gcloud services enable logging.googleapis.com
```

### **Step 1: Create the Terraform Configuration**

Create your `main.tf` file with the data security infrastructure. The code implements:

**Private Database Subnet:**
```hcl
# Private subnet for database with no external access
resource "google_compute_subnetwork" "db_private_subnet" {
  name                     = "${var.environment}-db-private-subnet"
  ip_cidr_range           = var.db_private_subnet_cidr
  region                  = var.region
  network                 = var.vpc_network_id
  project                 = var.project_id
  private_ip_google_access = true
  
  # Maximum security - no external IP access
  purpose = "PRIVATE"
  role    = "ACTIVE"
}
```

**Secure Cloud SQL Instance:**
```hcl
# Production-hardened PostgreSQL database
resource "google_sql_database_instance" "main_database" {
  name             = "${var.environment}-secure-postgres-db"
  database_version = var.database_version
  region          = var.region
  project         = var.project_id
  
  # Prevent accidental deletion in production
  deletion_protection = var.environment == "prod" ? true : false
  
  settings {
    tier              = var.database_tier
    availability_type = var.environment == "prod" ? "REGIONAL" : "ZONAL"
    disk_type        = "PD_SSD"
    disk_size        = var.database_disk_size
    
    # Security configurations
    backup_configuration {
      enabled                        = true
      start_time                    = "03:00"
      point_in_time_recovery_enabled = true
      transaction_log_retention_days = 7
    }
    
    # Network security - private IP only
    ip_configuration {
      ipv4_enabled    = false
      private_network = var.vpc_network_id
      enable_private_path_for_google_cloud_services = true
    }
    
    # Database security flags
    database_flags {
      name  = "log_connections"
      value = "on"
    }
    database_flags {
      name  = "log_disconnections"
      value = "on"
    }
  }
}
```

### **Step 2: Configure Variables**

Create your `terraform.tfvars` file with environment-specific values:

```hcl
# terraform.tfvars
project_id   = "your-project-id"
environment  = "dev"
region      = "us-central1"

# Network configuration (from previous modules)
vpc_network_id   = "projects/your-project-id/global/networks/my-app-vpc"
vpc_network_name = "my-app-vpc"

# Database configuration
database_version = "POSTGRES_15"
database_tier   = "db-f1-micro"  # Use db-custom-2-4096 for production
database_name   = "appdb"

# Security credentials (use strong passwords!)
app_db_username      = "appuser"
app_db_password      = "your-secure-password-here"
readonly_db_password = "your-readonly-password-here"

# Service account emails (from Module 2)
app_service_account_email = "app-tier-sa@your-project-id.iam.gserviceaccount.com"

# Admin access (restrict to your IP)
admin_ip_ranges = ["YOUR.IP.ADDRESS.HERE/32"]
```

### **Step 3: Deploy the Data Infrastructure**

```bash
# Initialize Terraform
terraform init

# Review the planned changes (should show ~15 resources to create)
terraform plan

# Deploy the secure data infrastructure
terraform apply
```

**What Gets Created:**
- 🗄️ **Cloud SQL PostgreSQL Instance** (private, encrypted, monitored)
- 🔐 **Database Users** (app user + read-only user with minimal permissions)
- 🗃️ **Application Database** (properly configured with UTF8)
- 🪣 **Cloud Storage Bucket** (encrypted, versioned, lifecycle managed)
- 🔑 **Secret Manager Secrets** (secure credential storage)
- 🔥 **Firewall Rules** (database access controls)
- 📊 **Monitoring Alerts** (connection monitoring and anomaly detection)
- 📝 **Audit Logging** (compliance and forensics)

## ✅ Validation and Security Testing

### **🔍 Verify Database Security**

**Check Private Networking:**
1. Navigate to **SQL** in GCP Console
2. Click on your database instance
3. Go to **Connections** tab
4. ✅ **Verify**: "Public IP" should show "Not configured"
5. ✅ **Verify**: "Private IP" should show an internal IP address

**Check Backup Configuration:**
1. In the database instance, go to **Backups**
2. ✅ **Verify**: Automated backups are enabled
3. ✅ **Verify**: Point-in-time recovery is enabled
4. ✅ **Verify**: Backup retention matches your requirements

**Test Database Connectivity:**
```bash
# This should FAIL (no public access)
psql -h PUBLIC_IP -U appuser -d appdb

# This should work from an authorized network
psql -h PRIVATE_IP -U appuser -d appdb
```

### **🔐 Verify Access Controls**

**Check Service Account Permissions:**
1. Navigate to **IAM & Admin** → **IAM**
2. Filter by your app service account
3. ✅ **Verify**: Has minimal required permissions only
4. ✅ **Verify**: No overly broad roles like "Editor" or "Owner"

**Test Secret Manager Access:**
```bash
# Test secret access (should work for authorized service accounts)
gcloud secrets versions access latest --secret="dev-db-connection-string"
```

### **📊 Verify Monitoring and Alerting**

**Check Monitoring Setup:**
1. Navigate to **Monitoring** → **Alerting**
2. ✅ **Verify**: Database connection alert policy exists
3. ✅ **Verify**: Notification channels are configured

**Check Audit Logging:**
1. Navigate to **Logging** → **Logs Explorer**
2. Filter: `resource.type="cloudsql_database"`
3. ✅ **Verify**: Database connection logs are being captured

## 🔒 Security Controls Implemented

| Security Control | Implementation | Benefit |
|-----------------|----------------|---------|
| **🔐 Encryption at Rest** | Google-managed encryption keys | Data protected even if disks are stolen |
| **🔐 Encryption in Transit** | SSL/TLS required for all connections | Data protected during transmission |
| **🚫 No Public Access** | Private IP only, no external connectivity | Eliminates internet-based attacks |
| **👤 Least Privilege Users** | Minimal database permissions per user | Limits blast radius of compromised accounts |
| **🔑 Secret Management** | Credentials stored in Secret Manager | No hardcoded passwords in code |
| **📊 Connection Monitoring** | Real-time alerts for anomalies | Early detection of suspicious activity |
| **📝 Audit Logging** | Complete connection and query logging | Forensics and compliance evidence |
| **💾 Automated Backups** | Point-in-time recovery enabled | Data recovery from corruption or deletion |
| **🔥 Network Controls** | Firewall rules restrict database access | Network-level access control |
| **⚠️ Deletion Protection** | Prevents accidental database deletion | Protects against human error |

## 💥 Attack Scenarios This Prevents

### **Scenario 1: Web Application Compromise**
**Attack**: Attacker gains control of web server through application vulnerability
**Protection**: Database is on private network with no direct access from web tier
**Result**: Attacker cannot directly access database even with web server control

### **Scenario 2: Credential Theft**
**Attack**: Database credentials are stolen from application code
**Protection**: Credentials stored in Secret Manager, not in code
**Result**: Stolen credentials are rotatable and access is logged

### **Scenario 3: SQL Injection**
**Attack**: Attacker attempts SQL injection through application
**Protection**: Database user has minimal permissions, connections are logged
**Result**: Limited damage scope, attack is detected and logged

### **Scenario 4: Insider Threat**
**Attack**: Malicious insider attempts unauthorized database access
**Protection**: All connections logged, IP restrictions, least privilege access
**Result**: Unauthorized access is detected and prevented

## 🎯 Production Hardening Checklist

For production deployments, implement these additional security measures:

### **Enhanced Security**
- [ ] **Customer-Managed Encryption Keys (CMEK)**: Use Cloud KMS for encryption key management
- [ ] **VPC Service Controls**: Implement security perimeters around data
- [ ] **Private Google Access**: Ensure no traffic leaves Google's network
- [ ] **Database Activity Monitoring**: Implement real-time query analysis
- [ ] **Backup Encryption**: Verify backups are encrypted with appropriate keys

### **Access Controls**
- [ ] **IP Allowlisting**: Restrict admin access to specific IP ranges
- [ ] **Multi-Factor Authentication**: Require MFA for all database access
- [ ] **Regular Access Reviews**: Audit and rotate database credentials
- [ ] **Principle of Least Privilege**: Regular review of user permissions
- [ ] **Service Account Key Rotation**: Implement automated key rotation

### **Monitoring and Compliance**
- [ ] **SIEM Integration**: Forward logs to security information and event management system
- [ ] **Compliance Scanning**: Regular compliance posture assessment
- [ ] **Penetration Testing**: Regular security testing of data layer
- [ ] **Incident Response Plan**: Documented procedures for data breaches
- [ ] **Data Classification**: Implement data sensitivity labeling

## 📚 Understanding the Security Architecture

### **Why Private Networking?**
By placing the database on a private subnet with no external IP, we eliminate the entire class of internet-based attacks. Even if an attacker discovers database credentials, they cannot reach the database without first compromising our internal network.

### **Why Secret Manager?**
Hardcoded credentials in application code are a major security vulnerability. Secret Manager provides secure storage, automatic rotation capabilities, and audit trails for all credential access.

### **Why Comprehensive Logging?**
In security, visibility is everything. Our logging strategy captures:
- **Connection logs**: Who connected when and from where
- **Query logs**: What operations were performed
- **Administrative actions**: All database configuration changes
- **Access logs**: All attempts to access secrets and storage

### **Why Multiple Database Users?**
The principle of least privilege applies to database access. Our architecture creates:
- **Application user**: Minimal permissions for normal operations
- **Read-only user**: For reporting and analytics
- **Admin user**: For database administration (not used by applications)

## 🔄 What's Next?

**Module 4: Infrastructure Hardening** awaits! We'll secure the compute layer with:
- 🖥️ **Hardened Virtual Machines** with security baselines
- 🔐 **OS-Level Security Controls** and monitoring
- 🛡️ **Runtime Security** and intrusion detection
- 📦 **Container Security** for modern applications

## 📖 Additional Resources

### **GCP Data Security**
- [Cloud SQL Security Best Practices](https://cloud.google.com/sql/docs/postgres/security-best-practices)
- [Secret Manager Documentation](https://cloud.google.com/secret-manager/docs)
- [Cloud Storage Security](https://cloud.google.com/storage/docs/security)

### **Compliance and Standards**
- [SOC 2 Compliance on GCP](https://cloud.google.com/security/compliance/soc-2)
- [GDPR Compliance Guide](https://cloud.google.com/privacy/gdpr)
- [PCI DSS on Google Cloud](https://cloud.google.com/security/compliance/pci-dss)

### **Security Best Practices**
- [Database Security Checklist](https://cloud.google.com/sql/docs/postgres/security-checklist)
- [Data Encryption Best Practices](https://cloud.google.com/docs/security/encryption-at-rest)
- [Identity and Access Management](https://cloud.google.com/iam/docs/overview)

---

**🗄️ Remember: Data is your most valuable asset and your greatest liability. This module implements enterprise-grade protection that treats data security with the gravity it deserves. Every control we've implemented has prevented real-world breaches at major companies.**
