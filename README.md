# GCP Security Training Lab: 3-Tier Architecture

**Hands-on, modular security training for Google Cloud Platform**

A practical security lab that teaches GCP security fundamentals through progressive modules. Each module adds security layers to a 3-tier web application, building from basic network controls to advanced enterprise security patterns.

## 🎯 Training Philosophy

**Learning by Building**: Deploy real infrastructure, not theoretical examples  
**Progressive Complexity**: Start simple, add advanced security layer by layer  
**Infrastructure as Code**: Everything in Terraform for repeatability and best practices  
**Security First**: Every decision explained through a security lens  
**Enterprise Ready**: Patterns used in real production environments  

## 🏗️ Lab Architecture

You'll build this secure 3-tier architecture progressively:

```
Internet → Cloud Load Balancer → Web Tier (Public Subnet)
                ↓ (Controlled Access)
           App Tier (Private Subnet)  
                ↓ (Database Only)
         Database Tier (Private Subnet)
```

Each module adds security controls and explains the "why" behind every configuration.

## 📚 Training Modules

### **Core Security Modules** (Complete in Order)

#### **[Module 1: Network Segmentation & Firewalls](./modules/01-network-security/)**
- **Focus**: Foundation security through network controls
- **You'll Learn**: VPC design, subnet isolation, firewall rules, network tags
- **Security Skills**: Network segmentation, least privilege networking, defense in depth
- **Deliverables**: Secure VPC with isolated tiers and proper firewall rules

#### **[Module 2: Identity & Access Management](./modules/02-iam-security/)**
- **Focus**: Service accounts, workload identity, and access controls  
- **You'll Learn**: IAM best practices, service account security, key management
- **Security Skills**: Least privilege access, identity federation, credential security
- **Deliverables**: Properly secured service accounts with minimal permissions

#### **[Module 3: Data Tier Security](./modules/03-data-security/)**
- **Focus**: Database security and encryption
- **You'll Learn**: Private Cloud SQL, CMEK, SSL enforcement, backup security
- **Security Skills**: Data protection, encryption at rest/transit, database hardening
- **Deliverables**: Fully secured database tier with enterprise-grade controls

#### **[Module 4: Infrastructure Hardening](./modules/04-infra-hardening/)**
- **Focus**: Compute security and instance hardening
- **You'll Learn**: Secure startup scripts, non-root execution, hardened images, MIG security
- **Security Skills**: System hardening, runtime security, auto-scaling security
- **Deliverables**: Hardened compute instances following security best practices

#### **[Module 5: Web Tier & Load Balancer Security](./modules/05-web-security/)**
- **Focus**: Public-facing security controls
- **You'll Learn**: HTTPS, SSL policies, Identity-Aware Proxy, Cloud Armor WAF
- **Security Skills**: Web application security, DDoS protection, access proxy patterns
- **Deliverables**: Production-ready web tier with comprehensive security controls

### **Advanced Security Add-Ons** (Optional - Pick What Interests You)

#### **[Advanced Lab: Organization Policies](./advanced-labs/org-policies/)**
- **Focus**: Organizational security governance
- **Controls**: External IP restrictions, CMEK enforcement, allowed regions, resource constraints
- **Real-World Use**: Enterprise security compliance and governance

#### **[Advanced Lab: VPC Service Controls](./advanced-labs/vpc-service-controls/)**
- **Focus**: Data exfiltration protection
- **Controls**: Service perimeters around Cloud SQL and Cloud Storage
- **Real-World Use**: Protecting sensitive data from insider threats and compromised credentials

#### **[Advanced Lab: Security Command Center Integration](./advanced-labs/security-command-center/)**
- **Focus**: Centralized security monitoring and response
- **Controls**: Automated finding detection, remediation workflows, compliance reporting
- **Real-World Use**: Enterprise security operations and incident response

#### **[Advanced Lab: Logging & Monitoring](./advanced-labs/logging-monitoring/)**
- **Focus**: Security observability and alerting
- **Controls**: Cloud Logging, Cloud Monitoring, Audit Logs, security alerting
- **Real-World Use**: Security operations center (SOC) implementation

## 🚀 Getting Started

### Prerequisites
- **GCP Account**: Project with billing enabled
- **Terraform**: v1.0+ installed locally
- **gcloud CLI**: Authenticated and configured
- **Basic Knowledge**: Linux command line, basic networking concepts

### Quick Start
```bash
# Clone the repository
git clone [your-repo-url]
cd gcp-security-training

# Start with Module 1
cd modules/01-network-security
terraform init
terraform plan
terraform apply
```

### Recommended Learning Path

1. **Week 1**: Complete Modules 1-2 (Network & IAM fundamentals)
2. **Week 2**: Complete Modules 3-4 (Data & Infrastructure security)  
3. **Week 3**: Complete Module 5 (Web tier security)
4. **Week 4+**: Choose advanced labs based on your interests/role

## 📖 Module Structure

Each module follows this consistent structure:

```
modules/XX-module-name/
├── README.md                 # Module learning objectives & theory
├── main.tf                   # Primary Terraform configuration
├── variables.tf              # Input variables and descriptions
├── outputs.tf                # Important outputs for next modules
├── terraform.tfvars.example  # Example variable values
├── security-validation/      # Scripts to test security controls
│   ├── test-controls.sh      # Automated security testing
│   └── attack-scenarios.md   # What happens if you skip this module
└── docs/                     # Additional documentation
    ├── security-theory.md    # Why these controls matter
    └── troubleshooting.md    # Common issues and solutions
```

## 🔍 What You'll Master

### **Technical Skills**
- **Infrastructure as Code**: Terraform for security-focused deployments
- **GCP Security Services**: Native security controls and configurations
- **Network Security**: VPC design, firewall rules, network segmentation
- **Identity Management**: Service accounts, workload identity, IAM best practices
- **Data Protection**: Encryption, private networking, backup security
- **Web Security**: HTTPS, WAF, DDoS protection, access controls
- **Monitoring & Logging**: Security observability and incident response

### **Security Concepts**
- **Defense in Depth**: Multiple layers of security controls
- **Zero Trust Architecture**: Never trust, always verify
- **Least Privilege**: Minimal required access at every level
- **Security by Design**: Building security into infrastructure from the start
- **Compliance**: Meeting enterprise security standards and regulations

### **Career Applications**
- **Cloud Security Engineer**: Hands-on GCP security implementation
- **Security Architect**: Designing secure cloud architectures  
- **DevSecOps Engineer**: Integrating security into CI/CD pipelines
- **Compliance Manager**: Understanding technical security controls
- **Penetration Tester**: Understanding cloud attack surfaces and defenses

## 🎯 Certification Alignment

This lab directly supports these Google Cloud certifications:
- **Professional Cloud Security Engineer** (Primary target)
- **Professional Cloud Architect** (Security domain)
- **Professional Cloud Network Engineer** (Security aspects)

## 🧪 Hands-On Validation

Every module includes practical security testing:
- **Automated Tests**: Scripts that verify your security controls work
- **Attack Scenarios**: Examples of what happens when controls are missing
- **Log Analysis**: How to detect and respond to security events
- **Compliance Checks**: Validating configurations against security standards

## 🚨 Real-World Impact

**Common Attack Scenarios This Lab Prevents:**
- Data exfiltration through compromised web applications
- Lateral movement between application tiers
- Database direct access from internet
- Privilege escalation through over-permissioned service accounts
- DDoS attacks against application infrastructure
- Man-in-the-middle attacks through unencrypted communications

## 📊 Progress Tracking

Track your learning progress:

- [ ] **Module 1**: Network security foundation
- [ ] **Module 2**: Identity and access controls  
- [ ] **Module 3**: Data tier protection
- [ ] **Module 4**: Infrastructure hardening
- [ ] **Module 5**: Web security implementation
- [ ] **Advanced Lab**: Organization policies
- [ ] **Advanced Lab**: VPC Service Controls
- [ ] **Advanced Lab**: Security Command Center
- [ ] **Advanced Lab**: Logging & monitoring

## 🤝 Contributing

This is a living training resource! Contributions welcome:
- **Bug Fixes**: Terraform improvements, documentation updates
- **New Modules**: Additional security patterns and use cases
- **Real-World Scenarios**: More attack/defense examples
- **Tool Integration**: Support for additional security tools

## 📧 Support

**Getting Stuck?**
1. Check the module's `troubleshooting.md` file
2. Review the `security-validation/` scripts for debugging
3. Open an issue with your Terraform state and error messages

**Want to Contribute?**
1. Fork the repository
2. Create a feature branch
3. Test your changes thoroughly  
4. Submit a pull request with clear documentation

---

## 🎓 Ready to Build Secure Infrastructure?

**Start with Module 1** and begin your hands-on GCP security journey. Every command teaches a security concept, every configuration follows industry best practices.

*No fluff. No theory-only. Just practical security skills you'll use in production.*

**[→ Begin Module 1: Network Segmentation & Firewalls](./modules/01-network-security/)**
