# 🔒 Module 3: Building a Secure Cloud SQL Instance via Console

> **A comprehensive guide to manually provisioning a production-ready PostgreSQL database in Google Cloud Platform**

---

## 🎯 Objective

Manually provision a secure, production-ready Cloud SQL for PostgreSQL instance, focusing on critical security settings like **network isolation** and **credential management**.

## 📋 Prerequisites

Before starting this module, ensure you have:

- [ ] A custom VPC named `my-app-vpc` created from Module 1
- [ ] The following APIs enabled for your project:
  - `servicenetworking.googleapis.com`
  - `sqladmin.googleapis.com`

---

## 🚀 Part 1: Securely Storing the Database Password

> 🔐 **Security First**: A secure application never stores passwords in plain text. We'll use Google Secret Manager as our digital vault.

### Steps:

1. **Navigate to Secret Manager**
   - In the GCP Console: `Security` → `Secret Manager`

2. **Create New Secret**
   - Click **✅ CREATE SECRET**
   - **Name**: `db-root-password-manual`
   - **Secret value**: Enter a strong, complex password

3. **Configuration**
   - **Replication policy**: Leave as `Automatic`
   - Click **CREATE SECRET**

> 💡 **Pro Tip**: Use a password manager to generate and save this password. For this lab, something like `!_Str0ng_P@ssw0rd_!2025` will work.

---

## 🌐 Part 2: Establishing the Private Network Connection

> ⚠️ **Critical Step**: This creates a secure, private bridge between your VPC and Google's internal network, ensuring traffic never touches the public internet.

### Steps:

1. **Navigate to Private Service Connection**
   - Go to: `VPC network` → `Private service connection`

2. **Create Connection**
   - Select **PRIVATE SERVICES ACCESS** tab
   - Click **CREATE CONNECTION**
   - Enable the Service Networking API when prompted

3. **Configure IP Range**
   - Choose **Allocate a new IP range**
   - **Name**: `private-service-access-range-manual`
   - **IP address range**: `10.50.0.0/16` (or use suggested range)
   - Click **CONTINUE**

4. **Finalize Connection**
   - Click **✅ CREATE CONNECTION**
   - Wait for the connection to become active (may take a few minutes)

---

## 💾 Part 3: Creating the Secure Cloud SQL Instance

With our password secured and private network established, let's create the database instance.

### Basic Configuration:

1. **Navigate to SQL**
   - Go to: `Databases` → `SQL`
   - Click **CREATE INSTANCE** → **PostgreSQL**

2. **Instance Information**
   ```
   Instance ID: my-app-db-manual
   Password: [Use the password from Secret Manager]
   Database version: PostgreSQL 13
   Region: us-central1 (or your preferred region)
   ```

3. **Show Configuration Options**
   - Click **SHOW CONFIGURATION OPTIONS** for advanced settings

### 🔒 Critical Security Settings:

#### Connections Tab (MOST IMPORTANT):
- [ ] **Uncheck** `Public IP` ⚠️ **Critical for security**
- [ ] **Check** `Private IP`
- [ ] **Network**: Select `my-app-vpc`

#### Machine Type Tab:
- **Type**: `Shared core`
- **Size**: `db-f1-micro` (for cost optimization)

#### Data Protection Tab:
- [ ] **Automate backups**: Enabled (default)
- [ ] **Enable deletion protection**: ✅ **Essential safety net**

4. **Create Instance**
   - Review all settings
   - Click **CREATE INSTANCE**
   - Wait 5-10 minutes for provisioning

---

## ✅ Part 4: Verification

Let's confirm our security configuration is correct:

### 🔍 Network Isolation Check:
1. Navigate to SQL instances → `my-app-db-manual`
2. On the Overview page, verify:
   - ❌ **Public IP address**: `Not assigned`
   - ✅ **Private IP address**: `Assigned and visible`

### 🛡️ Resilience Settings Check:
1. In the Configuration card, confirm:
   - ✅ **Deletion protection**: `Enabled`

### 🔐 Credential Storage Check:
1. Return to Secret Manager
2. Verify `db-root-password-manual` secret exists

---

## 🧠 Learning Synthesis

### 🎉 Congratulations!

You have successfully built a secure database infrastructure with:

- ✅ **Network Isolation**: Database only accessible via private IP
- ✅ **Credential Security**: Password stored in Secret Manager
- ✅ **Data Protection**: Automated backups and deletion protection
- ✅ **Cost Optimization**: Right-sized for development/testing

### 🔄 Next Steps

Now that you understand the manual process and the reasoning behind each security decision, you're ready to **automate this entire setup using Terraform** in the next part of this module.

---

## 📚 Key Takeaways

| Component | Purpose | Security Benefit |
|-----------|---------|------------------|
| Secret Manager | Password storage | Eliminates hardcoded credentials |
| Private Service Connection | Network isolation | Traffic stays off public internet |
| Private IP only | Database access control | Prevents unauthorized external access |
| Deletion protection | Data safety | Prevents accidental data loss |

---

## 🔄 Integration with Previous Modules

This secure database integrates with:

- **Module 1**: Database uses the private service connection established in the custom VPC network
- **Module 2**: `db-admin-sa` service account provides secure, least-privilege access to the database
- **Module 4**: App tier VMs will connect to this database using private networking only
- **Future Modules**: Connection strings and credentials will be managed through secure configuration

---

## 🏷️ Tags

`#GoogleCloud` `#CloudSQL` `#PostgreSQL` `#Security` `#DatabaseManagement` `#Infrastructure`

---

<div align="center">
  <strong>Ready to automate? Proceed to the Terraform module! 🚀</strong>
</div>