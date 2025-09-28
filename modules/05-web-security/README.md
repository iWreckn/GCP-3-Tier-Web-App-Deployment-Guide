# 🔐 Module 5: Securing the Edge - Global Load Balancer & WAF

Welcome to the **capstone module** of our core security lab! You've built a secure network, established strong identities, hardened your compute instances, and isolated your data. Now, it's time to build the most critical piece of our public-facing infrastructure: the **intelligent and secure front door**.

This module ties everything together by safely exposing our resilient web tier to the internet through a production-grade Global Load Balancer, complete with a Web Application Firewall (WAF).

---

## 🎯 What You'll Achieve

By the end of this module, you will have a complete, defense-in-depth architecture with a secure, scalable, and intelligent edge.

**Your Deliverables:**

*   A **Global External HTTPS Load Balancer** to distribute traffic to your web tier.
*   A **Google-managed SSL certificate** to enforce HTTPS and encrypt all user traffic.
*   A **Cloud Armor WAF policy** to protect your application from common web attacks and DDoS threats.
*   A **reserved global static IP address** to provide a stable, permanent entry point for your application.

## 🛡️ The 'Why' Behind the 'What': Core Edge Security Principles

This module focuses on securing the boundary between the public internet and your private infrastructure.

### Encryption in Transit (HTTPS Everywhere)
Unencrypted HTTP traffic is a major security risk, allowing attackers to intercept and read sensitive user data. By using a Google-managed SSL certificate and an HTTPS load balancer, we enforce **encryption for all traffic** entering our system, protecting user privacy and data integrity. This is a non-negotiable standard for any modern web application.

### Web Application Firewall (WAF)
A standard network firewall inspects traffic based on IP addresses and ports. A **WAF** is much smarter; it inspects the actual content of web traffic (Layer 7) to identify and block common attacks like **SQL Injection (SQLi)** and **Cross-Site Scripting (XSS)**, which are part of the OWASP Top 10 vulnerabilities. Cloud Armor acts as our WAF, serving as a powerful shield for our application.

### Global Availability and DDoS Protection
A Global Load Balancer doesn't just route traffic; it leverages Google's massive global network to route users to the closest, healthiest backend. This same infrastructure provides powerful, built-in protection against volumetric Distributed Denial-of-Service (DDoS) attacks, absorbing malicious traffic at the edge before it ever reaches your VMs.

### Centralized Ingress and Policy Enforcement
By forcing all traffic through a single, managed entry point, we can consistently enforce security policies. Our Cloud Armor WAF policy, SSL policy, and routing rules are all applied at the load balancer, ensuring no traffic can bypass these critical security controls.

## 🏗️ Our Blueprint: The Complete Secure Architecture

This is the final architecture, showing how the Global Load Balancer and WAF protect our 3-tier application.

```
                          🌍 Internet Traffic
                                 ↓
                    🔒 HTTPS Load Balancer + WAF
                         (lb-static-ip)
                                 ↓
    ┌─────────────────────────────────────────────────────────────┐
    │                      my-app-vpc                             │
    │                                                             │
    │  ┌───────────────────────┐    ┌─────────────────────────┐   │
    │  │     Web Tier MIG      │───▶│      App Tier VM        │   │
    │  │   (web-subnet)        │    │    (app-subnet)         │───┐
    │  │                       │    │                         │   │
    │  │  🌐 web-server-vm-1    │    │  ⚙️ app-server-1        │   │
    │  │  🌐 web-server-vm-2    │    │   • Private IP only     │   │
    │  └───────────────────────┘    └─────────────────────────┘   │
    └─────────────────────────────────────────────────────────────┘
                                                                  │
                         ┌─────────────────────────────────────────┘
                         ▼
                    🗄️ Private Cloud SQL
                     (PostgreSQL)
```

## 🚀 Let's Build: Hands-On Lab

We will use Terraform to define all the components of our secure edge.

### Step 1: Reserve a Global Static IP Address
We'll start by reserving a permanent, global IP address. This ensures our application's DNS entry point never changes.

### Step 2: Create the Backend Service and Health Check
Next, we'll define a backend service that points to the Managed Instance Group (MIG) we created in Module 4. We'll attach a health check to ensure the load balancer only sends traffic to healthy web servers.

### Step 3: Configure the HTTPS Frontend
This involves creating the "frontend" of the load balancer, which includes:
*   A **Google-managed SSL certificate** for our domain.
*   A **Target HTTPS Proxy** to terminate SSL connections.
*   A **URL Map** to route incoming requests to our backend service.
*   A **Forwarding Rule** to tie our static IP address to the target proxy.

### Step 4: Create and Attach the Cloud Armor WAF Policy
Finally, we'll define a Cloud Armor policy with rules (e.g., block traffic from certain regions, mitigate common attacks) and attach it to our backend service.

### Deploy the Infrastructure

Run the standard Terraform commands in your environment directory to deploy the secure edge.

```bash
# Initialize Terraform
terraform init

# Review the planned changes
terraform plan

# Apply the changes
terraform apply
```

## ✔️ Verify Your Work

After `terraform apply` completes (which can take several minutes for the load balancer), validate your setup.

1.  **Verify the Load Balancer:**
    *   Navigate to **Network Services -> Load balancing**.
    *   Find your load balancer and confirm it has a green checkmark and is using your reserved static IP.

2.  **Test HTTPS Connectivity:**
    *   Open a browser and navigate to `https://your-domain.com`.
    *   You should see the default NGINX page from your web servers, and your browser should show a valid lock icon, indicating a secure HTTPS connection.

3.  **Verify the WAF Policy:**
    *   Navigate to **Network Security -> Cloud Armor**.
    *   Find your WAF policy. Click on it and verify it's attached to your backend service.

## 💥 What This Prevents

*   **Eavesdropping:** Enforcing HTTPS prevents attackers from sniffing unencrypted traffic between users and your application.
*   **Common Web Exploits:** The Cloud Armor WAF helps block OWASP Top 10 attacks like SQL Injection and Cross-Site Scripting.
*   **DDoS Attacks:** The global load balancer absorbs and mitigates large-scale volumetric attacks at Google's edge.
*   **Direct Server Access:** By routing all traffic through the load balancer, we prevent attackers from directly targeting our web server VMs.

## 🎉 Congratulations!

You have now built a complete, secure, and resilient 3-tier application infrastructure on GCP, from the private data tier all the way to the secure public edge. You have the foundational, hands-on skills to design and build production-grade cloud systems with a security-first mindset.