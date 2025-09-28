# 🔐 Module 4: Hardening Compute Engine Instances via Console

> **A comprehensive guide to manually deploying hardened, auto-healing virtual machines using enterprise security best practices**

---

## 🎯 Objective

Manually deploy **hardened, auto-healing virtual machines** for our web and app tiers. You will learn to apply **least-privilege identities**, configure **secure-by-default settings**, and build for **high availability**.

## 📋 Prerequisites

Before starting this module, ensure you have completed:

- [ ] **Module 1**: Custom VPC with `web-subnet` and `app-subnet` 
- [ ] **Module 1**: Firewall rules with `web-server` and `app-server` tags
- [ ] **Module 2**: Service Accounts `web-tier-sa` and `app-tier-sa`

---

## 🚀 Part 1: Hardening the App Tier (Single VM)

> **🔒 Security Focus**: Creating a completely private, locked-down VM for our application tier with **zero internet access**.

### Navigate to VM Instances
1. In the GCP Console, go to: `Compute Engine` → `VM instances`

### Create New Instance
1. Click **✅ CREATE INSTANCE**
2. **Name**: `app-server-1`
3. **Region/Zone**: Select your project's region (e.g., `us-central1`) and any zone (`us-central1-a`)

### 🔑 (CRITICAL) Identity and API Access
1. Scroll down to the **Identity and API access** section
2. **Service account**: Click the dropdown and select **`app-tier-sa`**

> 🧠 **The Why**: We are explicitly avoiding the overly-permissive "Compute Engine default service account." This is a core principle of **least privilege** - the instance identity has **zero permissions by default**.

### 🌐 (CRITICAL) Networking
1. Expand the **Advanced options** section, then click on **Networking**
2. **Network tags**: Add the tag `app-server`
   
   > 🔗 This links the VM to the firewall rule we created in Module 1
   
3. **Network interfaces**: Click the dropdown to edit the network interface
   - **Network**: Select `my-app-vpc`
   - **Subnetwork**: Select `app-subnet` 
   - **External IPv4 address**: Ensure this is set to **None** ⚠️
   
   > 🛡️ **Critical for Security**: This keeps our app tier completely private
   
4. Click **Done**

### 🛡️ (CRITICAL) Security Hardening
1. Expand the **Advanced options** section again, then click on **Security**
2. Under the **Shielded VM** section, turn **ON** the following toggles:
   - ✅ **Secure Boot**
   - ✅ **Enable vTPM**
   - ✅ **Enable Integrity Monitoring**

> 🧠 **The Why**: Shielded VM helps defend against advanced threats like boot-level malware and rootkits by providing **verifiable integrity** of your VM instances.

### 🔧 Provide Startup Script
1. Expand the **Advanced options** section, then click on **Management**
2. In the **Automation → Startup script** field, paste the following:

```bash
#!/bin/bash
sudo apt-get update
sudo apt-get install -y git nodejs npm
```

### Create the VM
1. Review the settings and click **CREATE**

---

## 🌐 Part 2: Building the Web Tier (Resilient Instance Group)

> **⚡ Resilience Focus**: For our public-facing web tier, a single VM isn't enough. We need **auto-healing** and **scalability**.

### Step 1: Create the Instance Template

> 📋 **Template Purpose**: A reusable "blueprint" for our web server VMs that ensures consistency and security.

#### Navigate to Templates
1. In the **Compute Engine** menu, navigate to: `Instance templates`
2. Click **✅ CREATE INSTANCE TEMPLATE**

#### Configure Template Basics
1. **Name**: `web-server-template`

#### Apply Security Hardening
Apply the **same hardening principles** as the app server:

1. **Identity and API access**: Select the `web-tier-sa` service account
2. **Advanced options → Networking**:
   - **Network tags**: Add the `web-server` tag
   - **Network interfaces**: Select `my-app-vpc` and `web-subnet`
3. **Advanced options → Security**:
   - ✅ Enable all three **Shielded VM** features
4. **Advanced options → Management**:
   - **Startup script**:
   ```bash
   #!/bin/bash
   sudo apt-get update
   sudo apt-get install -y nginx
   sudo systemctl start nginx
   ```

#### Create Template
1. Click **CREATE**

### Step 2: Create the Managed Instance Group (MIG)

> 🔄 **Auto-Healing Magic**: The MIG uses our template to create and manage a group of identical, self-healing VMs.

#### Navigate to Instance Groups
1. In the **Compute Engine** menu, navigate to: `Instance groups`
2. Click **✅ CREATE INSTANCE GROUP**

#### Configure Instance Group
1. **Name**: `web-server-mig`
2. **Instance template**: Select the `web-server-template` you just created
3. **Location**: Select **Single zone** and your chosen zone (e.g., `us-central1-a`)
4. **Number of instances**: Set this to `2`

#### 💚 (CRITICAL) Autohealing Configuration

> ⚡ **Availability Guarantee**: This feature ensures our application stays available. The MIG will automatically recreate any VM that becomes unhealthy.

1. **Health check**: Click the dropdown and select **Create a health check**
2. Configure the health check:
   ```
   Name: http-basic-check
   Protocol: HTTP
   Port: 80
   ```
3. Click **SAVE AND CONTINUE**
4. Click **CREATE**

> 🚀 The MIG will now begin provisioning **two hardened web server VMs** based on your template.

---

## ✅ Part 3: Verification & Security Validation

Let's confirm that our hardened infrastructure is correctly configured:

### 🔍 Verify App Server Security
1. Go to: `Compute Engine` → `VM instances`
2. Find `app-server-1` and verify:
   - ✅ **Internal IP**: Should be in app-subnet range (e.g., `10.0.2.x`)
   - ✅ **External IP**: Shows **None** (completely private)
3. Click the instance name, and on the details page verify:
   - ✅ **Service account**: `app-tier-sa`
   - ✅ **Shielded VM**: All three features enabled

### 🌐 Verify Web Tier MIG
1. Go to: `Compute Engine` → `Instance groups`
2. Your `web-server-mig` should show:
   - ✅ **Green checkmark** with `2` under the "Instances" column
3. Click the MIG's name and go to the **Instances** tab
4. Click on an individual instance to verify:
   - ✅ **Network tag**: `web-server`
   - ✅ **Service account**: `web-tier-sa`
   - ✅ **Shielded VM**: All features enabled

---

## 🏗️ Infrastructure Architecture Summary

```
                        🔐 Hardened Compute Layer
    
    ┌─────────────────────────────────────────────────────────────┐
    │                      my-app-vpc                             │
    │                                                             │
    │  ┌───────────────────────┐    ┌─────────────────────────┐   │
    │  │     Web Tier MIG      │    │      App Tier VM        │   │
    │  │   (web-subnet)        │    │    (app-subnet)         │   │
    │  │                       │    │                         │   │
    │  │  🌐 web-server-vm-1    │───▶│  ⚙️ app-server-1        │   │
    │  │  🌐 web-server-vm-2    │    │   • Private IP only     │   │
    │  │   • Auto-healing       │    │   • Shielded VM        │   │
    │  │   • Load balanced      │    │   • app-tier-sa        │   │
    │  │   • Shielded VM        │    │   • Zero permissions   │   │
    │  │   • web-tier-sa        │    │                         │   │
    │  └───────────────────────┘    └─────────────────────────┘   │
    └─────────────────────────────────────────────────────────────┘
```

---

## 🛡️ Security Hardening Summary

| Security Layer | Web Tier | App Tier | Protection Benefit |
|---------------|----------|----------|-------------------|
| **🔑 Identity** | `web-tier-sa` (zero permissions) | `app-tier-sa` (zero permissions) | Least privilege access |
| **🌐 Network** | Public IP + `web-server` tag | Private IP only + `app-server` tag | Network segmentation |
| **🛡️ Shielded VM** | Secure Boot + vTPM + Integrity | Secure Boot + vTPM + Integrity | Boot-level protection |
| **⚡ Availability** | Auto-healing MIG (2+ instances) | Single VM (can scale later) | High availability |
| **🔧 Configuration** | Automated via startup script | Automated via startup script | Consistent deployment |

---

## ✅ Security Validation Checklist

### Compute Hardening
- [ ] App server has **no external IP** (completely private)
- [ ] Both tiers use **custom service accounts** (not default)
- [ ] All instances have **Shielded VM** features enabled
- [ ] Network tags properly applied for **firewall targeting**

### Availability & Resilience  
- [ ] Web tier deployed as **Managed Instance Group**
- [ ] **Auto-healing** configured with HTTP health checks
- [ ] **Multiple instances** running for redundancy
- [ ] **Instance template** created for consistency

### Identity & Access
- [ ] **Zero default permissions** for all service accounts
- [ ] **Least privilege** principles implemented
- [ ] **No overprivileged** default service accounts used

---

## 🧠 Learning Outcomes

After completing this module, you will understand:

- ✅ **Compute Hardening**: Applying security controls at the VM level
- ✅ **Least Privilege Identity**: Using custom service accounts with minimal permissions
- ✅ **Network Isolation**: Creating completely private compute resources
- ✅ **Shielded VM Protection**: Defending against advanced boot-level threats
- ✅ **High Availability Design**: Building resilient, auto-healing infrastructure
- ✅ **Infrastructure Templates**: Creating reusable, consistent VM blueprints

---

## 🔄 Integration with Previous Modules

This compute layer builds upon:

- **Module 1**: VMs are deployed into the segmented network subnets with proper firewall targeting
- **Module 2**: Custom service accounts provide least-privilege identity for each compute tier  
- **Module 3**: App tier VMs will connect to the private Cloud SQL database

---

## 📈 Next Steps

With your hardened compute infrastructure deployed:

1. **🔒 Add a secure Cloud Load Balancer** in front of the web tier MIG (Module 5)
2. **🔗 Connect app tier to the database** using private networking
3. **📊 Implement monitoring and logging** for security visibility
4. **🤖 Automate the entire deployment** using Terraform
5. **🔧 Add application code** and deployment pipelines

---

## 🏷️ Tags

`#GoogleCloud` `#ComputeEngine` `#Security` `#ShieldedVM` `#ManagedInstanceGroup` `#LeastPrivilege`

---

<div align="center">
  <strong>🚀 In the final core module, we will put a secure, intelligent Cloud Load Balancer in front of our web tier MIG to safely expose it to the internet.</strong>
</div>