# 🔐 Module 4: Hardening the Compute Layer

Welcome to Module 4! So far, we've built a secure network perimeter and established least-privilege identities. Now, it's time to build the "engine" of our application: the **compute instances**. This module focuses on deploying hardened, resilient, and secure virtual machines for our web and app tiers.

---

## 🎯 What You'll Achieve

By the end of this module, you will have a production-ready compute layer that is secure by default and built for high availability.

**Your Deliverables:**

*   A **hardened, private Compute Engine instance** for the application tier, completely isolated from the internet.
*   A **resilient, auto-healing Managed Instance Group (MIG)** for the public-facing web tier.
*   A reusable **Instance Template** to ensure all web servers are built from a consistent, secure blueprint.
*   Practical application of the **least-privilege service accounts** created in Module 2.
*   Implementation of **Shielded VM** features to protect against advanced, boot-level threats.

## 🛡️ The 'Why' Behind the 'What': Core Security Principles

This module moves our security focus from the network to the operating system level. We're not just building servers; we're building *fortified* servers.

### Compute Hardening
Security isn't just about firewalls. Hardening involves configuring the operating system and VM settings to reduce the attack surface. We'll enable features that make the instance itself more resistant to compromise, assuming an attacker somehow bypasses our network defenses.

### Defense Against Advanced Threats (Shielded VM)
Sophisticated attackers target the boot process to install persistent malware (rootkits) that can be difficult to detect. **Shielded VM** is a critical defense that provides verifiable integrity of your instances. It ensures that the VM boots with a trusted software stack, protecting against boot-level and kernel-level attacks.

### Availability as a Security Principle
Security encompasses Confidentiality, Integrity, and **Availability**. An application that is offline due to a server failure or a denial-of-service attack is not secure. By using a **Managed Instance Group (MIG)** with auto-healing, we ensure our public-facing web tier is resilient and can automatically recover from failures, guaranteeing availability.

### Consistency Through Templates
Inconsistent server configurations are a major source of security vulnerabilities. An **Instance Template** acts as a "golden image" or blueprint. Every VM launched from the template is identical, ensuring that all security settings, service accounts, and network tags are applied consistently, every time.

## 🏗️ Our Blueprint: Target Architecture

This module adds the compute instances into the secure subnets we created in Module 1.

```
                        🔐 Hardened Compute Layer
    
    ┌─────────────────────────────────────────────────────────────┐
    │                      my-app-vpc                             │
    │                                                             │
    │  ┌───────────────────────┐    ┌─────────────────────────┐   │
    │  │     Web Tier MIG      │    │      App Tier VM        │   │
    │  │   (web-subnet)        │    │    (app-subnet)         │   │
    │  │                       │    │                         │   │
    │  │  🌐 web-server-vm-1    │───▶│  ⚙️ app-server-1     │   │
    │  │  🌐 web-server-vm-2    │   │   • Private IP only    │   │
    │  │   • Auto-healing       │   │   • Shielded VM         │   │
    │  │   • Load balanced      |   │   • app-tier-sa         │   │
    │  │   • Shielded VM        │   │   • Zero permissions    │   │
    │  │   • web-tier-sa        │   │                         │   │
    │  └───────────────────────┘    └─────────────────────────┘   │
    └─────────────────────────────────────────────────────────────┘
```

## 🚀 Let's Build: Hands-On Lab

We will continue using Terraform to define our hardened compute infrastructure.

### Step 1: Create the Instance Template for the Web Tier

First, we define the blueprint for our web servers. This template will specify the machine type, the secure service account, the network configuration, and the Shielded VM settings.

### Step 2: Create the Managed Instance Group (MIG)

Using the template, we'll create a MIG. This resource manages a group of identical VMs, ensuring they are running and healthy. We'll configure it to maintain two instances and use a health check to automatically recreate any that fail.

### Step 3: Create the Hardened App Tier VM

For the app tier, we'll create a single, standalone VM. The critical security configuration here is ensuring it has **no external IP address**, making it completely private and inaccessible from the internet. It will also use Shielded VM features and its own least-privilege service account.

### Deploy the Infrastructure

Run the standard Terraform commands in your environment directory to bring your hardened compute layer to life:

```bash
# Initialize Terraform (if you haven't already for this module)
terraform init

# Review the planned changes
terraform plan

# Apply the changes
terraform apply
```

## ✔️ Verify Your Work

After `terraform apply` completes, validate the security posture in the GCP Console.

1.  **Verify App Server Security:**
    *   Navigate to **Compute Engine -> VM instances**.
    *   Find your app server instance. Does it show **None** for the External IP?
    *   Click the instance. Does it use the `app-tier-sa` service account? Are Shielded VM features enabled?

2.  **Verify Web Tier Resilience:**
    *   Navigate to **Compute Engine -> Instance groups**.
    *   Click on your `web-server-mig`. Does it show 2 running instances?
    *   Check the **Health check** status. Is it healthy?
    *   Click on one of the instances created by the MIG. Does it have the `web-server` network tag and use the `web-tier-sa` service account?

## 💥 What This Prevents

*   **Boot-level Malware:** Shielded VM's Secure Boot and Integrity Monitoring help prevent rootkits and other persistent threats that compromise the OS at its core.
*   **Privilege Escalation:** By using least-privilege service accounts, a compromise of the VM does not automatically grant an attacker broad permissions across your GCP project.
*   **Downtime from Server Failure:** The auto-healing MIG ensures that if a web server crashes or becomes unresponsive, it is automatically replaced, maintaining application availability.
*   **Configuration Drift:** Using an instance template prevents manual, inconsistent server setups that often lead to security gaps.

## Next Up...

Excellent! You've built a hardened and resilient compute layer. In the final core module, we'll build the secure "front door" for our application: a **Global HTTPS Load Balancer with a Web Application Firewall (WAF)** to safely expose our web tier to the world.