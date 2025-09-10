# GCP Security Engineer Training: 3-Tier Architecture

**Hands-on security training for Google Cloud Platform through practical infrastructure deployment**

A comprehensive security-focused lab that teaches GCP security fundamentals by building a production-ready 3-tier web application architecture. Perfect for security engineers, cloud architects, and anyone wanting to understand GCP security controls in practice.

## 🎯 Learning Objectives

By completing this lab, you will master:

### **Network Security**
- ✅ VPC design and network segmentation strategies
- ✅ Subnet isolation and private networking concepts
- ✅ Firewall rule implementation using least privilege principles
- ✅ Network tags for security group management
- ✅ Private vs. public IP allocation strategies

### **Identity & Access Management**
- ✅ Service account security best practices
- ✅ Resource-level access controls
- ✅ GCP IAM role assignments and principles

### **Data Protection**
- ✅ Database security with Cloud SQL private networking
- ✅ Encryption in transit and at rest (GCP managed)
- ✅ Network-level database access controls

### **Infrastructure Security**
- ✅ Compute instance hardening and management
- ✅ Load balancer security configurations
- ✅ Managed instance group security patterns
- ✅ Startup script security considerations

### **Monitoring & Compliance**
- ✅ Security logging and audit trails
- ✅ Network flow monitoring capabilities
- ✅ Infrastructure as Code security practices

## 🏗️ Architecture Overview

You'll build a real-world security architecture following industry best practices:

```
Internet → Cloud Load Balancer → Web Tier (Public Subnet)
                                     ↓ (Port 3000 only)
                                App Tier (Private Subnet)
                                     ↓ (Port 5432 only)  
                              Database Tier (Private Subnet)
```

### **Security Zones**

| Tier | Network Access | Security Focus |
|------|----------------|----------------|
| **Web Tier** | Public (HTTP/HTTPS only) | DDoS protection, SSL termination |
| **App Tier** | Private (Web tier only) | Application logic isolation |
| **Data Tier** | Private (App tier only) | Database security, encryption |

## 📋 Prerequisites

- **GCP Account**: Active project with billing enabled
- **Basic Linux**: Command line familiarity
- **Networking Knowledge**: Basic understanding of TCP/IP, subnets
- **Security Mindset**: Understanding of defense in depth principles

### **Required Tools**
```bash
# Install and authenticate gcloud CLI
gcloud init

# Enable required APIs
gcloud services enable compute.googleapis.com
gcloud services enable sqladmin.googleapis.com
gcloud services enable logging.googleapis.com
```

## 🚀 Security Lab Deployment

### Phase 1: Network Security Foundation

The foundation of any secure cloud architecture starts with proper network design.

#### 1.1 Create Isolated VPC Network
```bash
# Custom VPC for complete control over network security
gcloud compute networks create secure-app-vpc --subnet-mode=custom
```

**Security Learning**: Why custom mode? Default networks lack security controls and use predictable IP ranges.

#### 1.2 Implement Network Segmentation
```bash
# DMZ - Web tier (public-facing)
gcloud compute networks subnets create web-dmz \
    --network=secure-app-vpc \
    --range=10.0.1.0/24 \
    --region=us-central1

# Internal - Application tier (private)
gcloud compute networks subnets create app-internal \
    --network=secure-app-vpc \
    --range=10.0.2.0/24 \
    --region=us-central1

# Data - Database tier (most restrictive)
gcloud compute networks subnets create data-zone \
    --network=secure-app-vpc \
    --range=10.0.3.0/24 \
    --region=us-central1
```

**Security Learning**: Each tier has isolated IP ranges following RFC 1918 private addressing.

#### 1.3 Implement Firewall Security Controls
```bash
# Allow public access to web tier (minimal required ports)
gcloud compute firewall-rules create allow-web-public \
    --network=secure-app-vpc \
    --allow=tcp:80,tcp:443 \
    --source-ranges=0.0.0.0/0 \
    --target-tags=web-tier \
    --description="Public HTTP/HTTPS access to web tier only"

# Allow SSH for management (consider restricting source IPs in production)
gcloud compute firewall-rules create allow-ssh-management \
    --network=secure-app-vpc \
    --allow=tcp:22 \
    --source-ranges=0.0.0.0/0 \
    --target-tags=web-tier,app-tier \
    --description="SSH access for system administration"

# Internal communication: Web → App
gcloud compute firewall-rules create allow-web-to-app \
    --network=secure-app-vpc \
    --allow=tcp:3000 \
    --source-tags=web-tier \
    --target-tags=app-tier \
    --description="Web tier to app tier communication"

# Internal communication: App → Database
gcloud compute firewall-rules create allow-app-to-database \
    --network=secure-app-vpc \
    --allow=tcp:5432 \
    --source-tags=app-tier \
    --target-tags=data-tier \
    --description="App tier to database communication"
```

**Security Learning**: Notice the progression from broad access (public web) to highly restrictive (database). Each rule follows least privilege principles.

### Phase 2: Data Tier Security

#### 2.1 Deploy Secure Database
```bash
# Create private Cloud SQL instance (no public IP)
gcloud sql instances create secure-app-db \
    --database-version=POSTGRES_13 \
    --tier=db-n1-standard-1 \
    --region=us-central1 \
    --root-password="[STRONG_PASSWORD_HERE]" \
    --network=projects/[YOUR_PROJECT_ID]/global/networks/secure-app-vpc \
    --no-assign-ip \
    --backup-start-time=03:00 \
    --enable-bin-log \
    --deletion-protection

# Get the private IP for app configuration
gcloud sql instances describe secure-app-db \
    --format='get(ipAddresses[0].ipAddress)'
```

**Security Learning**: 
- `--no-assign-ip`: No internet exposure
- Private IP within your VPC only
- Automatic backups and point-in-time recovery
- Deletion protection against accidental removal

### Phase 3: Application Tier Security

#### 3.1 Create Secure App Startup Script

Create `secure-app-startup.sh`:
```bash
#!/bin/bash
# Security-focused startup script

# Update system packages (security patches)
sudo apt-get update && sudo apt-get upgrade -y

# Install minimal required packages
sudo apt-get install -y netcat-openbsd curl

# Create non-root service user
sudo useradd -r -s /bin/false appuser

# Create simple test service (simulates your application)
sudo tee /opt/test-service.sh > /dev/null <<EOF
#!/bin/bash
# Simple HTTP service for testing network connectivity
while true; do
    echo -e "HTTP/1.1 200 OK\r\n\r\nApp Tier Security Test - $(date)" | nc -l -p 3000
done
EOF

sudo chmod +x /opt/test-service.sh

# Create systemd service running as non-root user
sudo tee /etc/systemd/system/test-app.service > /dev/null <<EOF
[Unit]
Description=Test App Service
After=network.target

[Service]
Type=simple
User=appuser
ExecStart=/opt/test-service.sh
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Enable and start the service
sudo systemctl enable test-app.service
sudo systemctl start test-app.service

# Configure basic host firewall (defense in depth)
sudo ufw --force enable
sudo ufw allow 22/tcp
sudo ufw allow 3000/tcp
```

**Security Learning**: 
- Non-root service execution
- Minimal package installation
- Host-level firewall (defense in depth)
- Automatic service restart on failure

#### 3.2 Deploy Secure App Instance
```bash
gcloud compute instances create secure-app-server \
    --zone=us-central1-a \
    --machine-type=e2-medium \
    --network-interface=subnet=app-internal,no-address \
    --tags=app-tier \
    --metadata-from-file=startup-script=secure-app-startup.sh \
    --service-account=[YOUR_PROJECT_NUMBER]-compute@developer.gserviceaccount.com \
    --scopes=logging-write \
    --boot-disk-size=20GB \
    --boot-disk-type=pd-ssd
```

**Security Learning**: 
- No external IP address (`no-address`)
- Minimal service account scopes
- Network tags for firewall targeting
- SSD for better performance and security

### Phase 4: Web Tier & Load Balancer Security

#### 4.1 Create Secure Web Startup Script

Create `secure-web-startup.sh`:
```bash
#!/bin/bash
# Secure web server deployment

# System updates
sudo apt-get update && sudo apt-get upgrade -y

# Install and configure Nginx
sudo apt-get install -y nginx

# Basic Nginx security configuration
sudo tee /etc/nginx/sites-available/secure-config > /dev/null <<EOF
server {
    listen 80;
    server_name _;
    
    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    
    # Hide Nginx version
    server_tokens off;
    
    # Basic rate limiting
    limit_req_zone \$binary_remote_addr zone=basic:10m rate=10r/s;
    limit_req zone=basic burst=20 nodelay;
    
    location / {
        root /var/www/html;
        index index.html;
    }
    
    # Health check endpoint
    location /health {
        return 200 'healthy';
        add_header Content-Type text/plain;
    }
}
EOF

sudo ln -sf /etc/nginx/sites-available/secure-config /etc/nginx/sites-enabled/default
sudo nginx -t && sudo systemctl restart nginx

# Configure host firewall
sudo ufw --force enable
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
```

#### 4.2 Create Instance Template & Managed Instance Group
```bash
# Create instance template for consistent deployments
gcloud compute instance-templates create secure-web-template \
    --machine-type=e2-small \
    --region=us-central1 \
    --network=secure-app-vpc \
    --subnet=web-dmz \
    --tags=web-tier \
    --metadata-from-file=startup-script=secure-web-startup.sh \
    --service-account=[YOUR_PROJECT_NUMBER]-compute@developer.gserviceaccount.com \
    --scopes=logging-write

# Create managed instance group for high availability
gcloud compute instance-groups managed create secure-web-group \
    --template=secure-web-template \
    --size=2 \
    --zone=us-central1-a
```

#### 4.3 Deploy Secure Load Balancer
```bash
# Health check for application availability
gcloud compute health-checks create http secure-health-check \
    --port=80 \
    --request-path=/health \
    --check-interval=30s \
    --timeout=10s \
    --healthy-threshold=2 \
    --unhealthy-threshold=3

# Backend service with security considerations
gcloud compute backend-services create secure-backend-service \
    --protocol=HTTP \
    --health-checks=secure-health-check \
    --global \
    --timeout=30s \
    --connection-draining-timeout=300s

# Add instance group to backend
gcloud compute backend-services add-backend secure-backend-service \
    --instance-group=secure-web-group \
    --instance-group-zone=us-central1-a \
    --global

# URL mapping and proxy configuration
gcloud compute url-maps create secure-url-map \
    --default-service=secure-backend-service

gcloud compute target-http-proxies create secure-http-proxy \
    --url-map=secure-url-map

# Global forwarding rule (public entry point)
gcloud compute forwarding-rules create secure-forwarding-rule \
    --address-name=secure-lb-ip \
    --global \
    --target-http-proxy=secure-http-proxy \
    --ports=80
```

## 🧪 Security Testing & Validation

### Test Your Security Controls

#### 1. Network Segmentation Testing
```bash
# Get your load balancer IP
LOAD_BALANCER_IP=$(gcloud compute addresses describe secure-lb-ip --global --format="get(address)")
echo "Load Balancer IP: $LOAD_BALANCER_IP"

# Test public access (should work)
curl http://$LOAD_BALANCER_IP

# Test direct access to app tier (should fail - no public IP)
gcloud compute instances list --filter="name:secure-app-server"
```

#### 2. Firewall Rule Validation
```bash
# SSH to app server through web tier (demonstrates network access)
gcloud compute ssh secure-app-server --zone=us-central1-a

# From app server, test database connectivity
nc -zv [DATABASE_PRIVATE_IP] 5432
```

#### 3. Security Audit Commands
```bash
# Review firewall rules
gcloud compute firewall-rules list --filter="network:secure-app-vpc"

# Check instance security settings
gcloud compute instances describe secure-app-server --zone=us-central1-a \
    --format="table(name,status,networkInterfaces[].accessConfigs[].natIP)"

# Review Cloud SQL security
gcloud sql instances describe secure-app-db \
    --format="table(name,ipAddresses[].type,ipAddresses[].ipAddress)"
```

## 🔍 What You've Learned

### **Core Security Concepts Mastered**

1. **Defense in Depth**: Multiple layers of security controls
2. **Least Privilege**: Minimal required access at each level  
3. **Network Segmentation**: Isolation between security zones
4. **Zero Trust Networking**: Never trust, always verify
5. **Managed Service Security**: Leveraging GCP security features

### **Practical GCP Security Skills**

- VPC design for security isolation
- Firewall rule implementation and testing
- Private networking configuration
- Load balancer security patterns
- Cloud SQL private instance deployment
- Instance template security hardening
- Service account minimal permissions

### **Real-World Applications**

This architecture pattern applies to:
- **Web Applications**: E-commerce, SaaS platforms
- **API Services**: Microservices architectures  
- **Data Processing**: ETL pipelines with database backends
- **Enterprise Applications**: CRM, ERP systems

## 🚨 Production Security Considerations

For production deployments, consider adding:

- **SSL/TLS**: HTTPS with managed certificates
- **Cloud Armor**: WAF and DDoS protection
- **Identity-Aware Proxy**: Advanced access controls
- **VPC Flow Logs**: Network traffic monitoring
- **Cloud Security Command Center**: Centralized security monitoring
- **Binary Authorization**: Container image security
- **Private Google Access**: API access without public IPs

## 🧹 Lab Cleanup

**Important**: Clean up resources to avoid unexpected charges.

```bash
# Delete in reverse order of dependencies
gcloud compute forwarding-rules delete secure-forwarding-rule --global -q
gcloud compute target-http-proxies delete secure-http-proxy -q
gcloud compute url-maps delete secure-url-map -q
gcloud compute backend-services delete secure-backend-service --global -q
gcloud compute health-checks delete secure-health-check -q
gcloud compute instance-groups managed delete secure-web-group --zone=us-central1-a -q
gcloud compute instance-templates delete secure-web-template -q
gcloud compute instances delete secure-app-server --zone=us-central1-a -q
gcloud sql instances delete secure-app-db -q
gcloud compute firewall-rules delete allow-web-public allow-ssh-management allow-web-to-app allow-app-to-database -q
gcloud compute networks subnets delete web-dmz app-internal data-zone --region=us-central1 -q
gcloud compute networks delete secure-app-vpc -q
```

## 📚 Next Steps

**Advanced Security Labs:**
- Implement Zero Trust with Identity-Aware Proxy
- Add Cloud Armor WAF protection
- Configure VPC Flow Logs and monitoring
- Deploy with Terraform for Infrastructure as Code
- Implement CI/CD security scanning

**Certification Paths:**
- Professional Cloud Security Engineer
- Professional Cloud Architect
- Professional Cloud Network Engineer

---

**🎓 Ready to level up your GCP security skills? Star this repo and start building!**

*Built for security engineers who learn by doing*
