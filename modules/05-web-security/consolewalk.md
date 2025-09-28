# 🔐 Module 5: Securing the Web Tier with Global Load Balancer & WAF

> **🎯 CAPSTONE MODULE**: The final core module that ties everything together by safely exposing our web tier to the internet with enterprise-grade security**

---

## 🏆 Welcome to the Final Core Module!

You've built the secure foundation, hardened the servers, and now it's time to build the **intelligent and secure front door**. This module ties everything together by safely exposing our web tier to the internet.

## 🎯 Objective

Manually deploy a **global load balancer** complete with a **Web Application Firewall (WAF)** via Cloud Armor and enforce **HTTPS traffic** with a Google-managed SSL certificate. This is the final step in building our **production-grade, secure 3-tier application**.

## 📋 Prerequisites

Before starting this capstone module, ensure you have completed:

- [ ] **Module 4**: Running Managed Instance Group (MIG) named `web-server-mig`
- [ ] **Module 4**: Basic HTTP health check named `http-basic-check`
- [ ] **All Previous Modules**: Complete secure infrastructure foundation

---

## 🌐 Part 1: Reserving a Static IP Address

> **🏢 Professional Foundation**: A production web application needs a stable, permanent IP address for reliability and DNS management.

### Navigate to IP Addresses
1. In the GCP Console, go to: `VPC network` → `IP addresses`

### Reserve Static IP
1. Click **✅ RESERVE EXTERNAL STATIC ADDRESS**
2. Configuration:
   ```
   Name: lb-static-ip
   Network Service Tier: Premium
   IP version: IPv4
   Type: Global
   ```
   
   > ⚠️ **Critical**: `Global` type is required for global load balancers
   
3. Click **RESERVE**

---

## 🔄 Part 2: Building the HTTPS Load Balancer

> **🏗️ Main Event**: The load balancer is not a single resource, but an orchestration of several components: backend, frontend, and routing rules.

### Navigate to Load Balancing
1. In the GCP Console, go to: `Network Services` → `Load balancing`
2. Click **✅ CREATE LOAD BALANCER**

### Initial Configuration
1. Under **Application Load Balancer (HTTP/S)**, click **START CONFIGURATION**
2. Configuration:
   ```
   Internet facing or internal: From Internet to my VMs or serverless services
   Global or Regional: Global external Application Load Balancer
   ```
3. Click **CONTINUE**
4. **Name**: `web-app-lb`

---

### Step A: Configure the Backend Service

> **🎯 Traffic Routing**: This tells the load balancer where to send traffic - your hardened web servers.

1. Click on **Backend configuration**
2. Select **Backend services & backend buckets** → **CREATE A BACKEND SERVICE**
3. Configuration:
   ```
   Name: web-backend-service
   Backend type: Instance group
   ```
4. **New backend section**:
   ```
   Instance group: web-server-mig (from Module 4)
   Port numbers: 80
   Health check: http-basic-check (from Module 4)
   ```
5. Click **CREATE**

---

### Step B: Configure the Frontend and Routing Rules

> **🌍 Public Interface**: This is the secure, encrypted public-facing part of the load balancer.

1. Click on **Frontend configuration**
2. Configuration:
   ```
   Name: https-frontend-rule
   Protocol: HTTPS (HTTP/2)
   IP address: lb-static-ip (select the reserved IP)
   ```

#### 🔒 (CRITICAL) SSL Certificate Configuration

1. Click the **Certificate** dropdown → **CREATE A NEW CERTIFICATE**
2. Configuration:
   ```
   Name: web-app-ssl-cert
   Create mode: Create Google-managed certificate
   Domains: app.your-domain.com (enter a domain you own)
   ```
   
   > ⚠️ **DNS Requirement**: For a real certificate to become active, you must update your domain's DNS A record to point to the `lb-static-ip`. For this lab, you can proceed without doing so, but the certificate will not fully provision.

3. Click **CREATE**, then **DONE** on the frontend configuration pane

---

### Step C: Review and Finalize

1. Verify green checkmarks next to:
   - ✅ **Backend configuration** 
   - ✅ **Frontend configuration**
2. Click **Review and finalize**
3. Verify all details are correct
4. Click **✅ CREATE**

> ⏱️ **Patience Required**: The load balancer will now be provisioned, which can take several minutes.

---

## 🛡️ Part 3: Activating the WAF (Cloud Armor)

> **🔥 Advanced Protection**: Attach a Web Application Firewall to protect against common attacks, DDoS, and geographic threats.

### Navigate to Cloud Armor
1. In the GCP Console, go to: `Network Security` → `Cloud Armor`
2. Click **✅ CREATE POLICY**

### Configure WAF Policy
1. Configuration:
   ```
   Name: web-app-waf-policy
   Policy type: Backend security policy
   Default rule action: Deny
   ```
   
   > 🛡️ **Best Practice**: `Deny` by default blocks anything we don't explicitly allow
   
2. Click **NEXT STEP**

### Add Allow Rule
1. Click **ADD RULE**
2. Configuration:
   ```
   Description: Allow traffic from the United States
   Action: Allow
   Match: origin.region_code == 'US'
   Priority: 1000
   ```
   
   > 🌍 **Geographic Protection**: This rule demonstrates geo-blocking capabilities. Lower priority numbers execute first.
   
3. Click **DONE**
4. Click **NEXT STEP**

### Attach Policy to Target
1. Click **ADD TARGET**
2. Configuration:
   ```
   Type: Backend service
   Region: Global
   Target: web-backend-service
   ```
3. Click **CREATE POLICY**

---

## ✅ Part 4: Final Verification & Testing

### 🔍 Verify Load Balancer Configuration
1. Go back to: `Network Services` → `Load balancing`
2. Click on your `web-app-lb`
3. ✅ **Verify**: The IP address listed matches your `lb-static-ip`

### 🌐 Test Connectivity
1. Open a web browser and navigate to: `https://<YOUR_STATIC_IP>`
2. **Expected**: Browser privacy warning (because certificate isn't fully trusted yet)
   
   > 💡 **Normal Behavior**: Click "Proceed" to continue
   
3. ✅ **Success**: You should see the "Welcome to nginx!" page served from your hardened MIG

### 🛡️ Verify WAF Policy
1. In the load balancer's details, click on `web-backend-service`
2. ✅ **Verify**: `web-app-waf-policy` is listed in the **Security** section

---

## 🏆 Complete Infrastructure Architecture

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
    │  │   • Auto-healing       │    │   • Shielded VM        │   │
    │  │   • Load balanced      │    │   • app-tier-sa        │   │
    │  │   • Shielded VM        │    │                         │   │
    │  │   • web-tier-sa        │    │                         │   │
    │  └───────────────────────┘    └─────────────────────────┘   │
    └─────────────────────────────────────────────────────────────┘
                                                                  │
                         ┌─────────────────────────────────────────┘
                         ▼
                    🗄️ Private Cloud SQL
                     (PostgreSQL)
                    • Private IP only
                    • Encrypted connections
                    • Automated backups
```

---

## 🎉 CORE LAB COMPLETE! 🏁

### **🎊 CONGRATULATIONS! 🎊**

You have successfully completed the **final core module**. You've built a **complete, secure, and resilient 3-tier application infrastructure** from the ground up!

---

## ✅ Complete Security Implementation Summary

| Layer | Component | Security Features | Module |
|-------|-----------|------------------|--------|
| **🌐 Edge** | Global Load Balancer + WAF | HTTPS encryption, DDoS protection, geo-blocking | **Module 5** |
| **🖥️ Compute** | Hardened VM instances | Shielded VM, least privilege, private networking | **Module 4** |
| **🗄️ Data** | Private Cloud SQL | Network isolation, encrypted storage, access control | **Module 3** |
| **🔑 Identity** | Custom Service Accounts | Zero Trust, least privilege, audit trails | **Module 2** |
| **🌐 Network** | Segmented VPC | Firewall rules, private subnets, tier isolation | **Module 1** |

---

## 🏆 What You've Mastered

### **🔒 Enterprise Security Principles**
- ✅ **Zero Trust Architecture** - No implicit permissions
- ✅ **Defense in Depth** - Multiple security layers  
- ✅ **Least Privilege Access** - Minimal required permissions
- ✅ **Network Segmentation** - Isolated application tiers
- ✅ **Encryption Everywhere** - Data in transit and at rest

### **🏗️ Production-Grade Infrastructure**
- ✅ **Global Traffic Management** with secure HTTPS Load Balancer
- ✅ **Auto-healing Infrastructure** with Managed Instance Groups
- ✅ **Web Application Firewall** protection against threats
- ✅ **Private Database Connectivity** with no internet exposure
- ✅ **Comprehensive Monitoring** and health checking

### **☁️ Google Cloud Expertise**
- ✅ **Advanced Networking** with custom VPC design
- ✅ **Compute Security** with Shielded VM hardening
- ✅ **Identity Management** with custom service accounts
- ✅ **Database Security** with private Cloud SQL
- ✅ **Edge Security** with Cloud Armor WAF

---

## 🚀 Next Steps: Advanced & Specialty Modules

Now that you have **foundational, hands-on skills** to design and build secure cloud infrastructure, you're ready to explore:

### **🏢 Advanced Security Modules**
- **Organization Policies** - Enterprise governance and compliance
- **VPC Service Controls** - Advanced perimeter security
- **Security Command Center** - Unified security monitoring
- **Binary Authorization** - Container image security

### **🔧 Automation & DevOps**
- **Terraform Infrastructure** - Full automation of this lab
- **CI/CD Pipelines** - Automated deployment workflows  
- **GitOps** - Infrastructure as code best practices

### **📊 Monitoring & Observability**
- **Cloud Operations Suite** - Comprehensive monitoring
- **Security Analytics** - Threat detection and response
- **Compliance Automation** - Regulatory requirement management

---

## 🔄 Integration with All Previous Modules

This capstone brings together the complete secure infrastructure:

- **Module 1**: Load balancer sits at the edge of your segmented network architecture
- **Module 2**: All components use least-privilege service accounts you created  
- **Module 3**: App tier securely connects to your private database
- **Module 4**: Load balancer distributes traffic to your hardened compute instances
- **Module 5**: WAF and HTTPS provide the final security layer

---

## 🏷️ Tags

`#GoogleCloud` `#LoadBalancer` `#WAF` `#CloudArmor` `#HTTPS` `#Security` `#CapstoneProject`

---

<div align="center">

## 🎓 **CERTIFICATION READY**

**You now have the foundational expertise to:**
- **Design secure cloud architectures**
- **Implement Zero Trust principles** 
- **Build production-grade infrastructure**
- **Apply enterprise security best practices**

---

### **🚀 Ready for Advanced Challenges!**

*Proceed to advanced modules on Org Policies, VPC Service Controls, and specialized security topics!*

</div>