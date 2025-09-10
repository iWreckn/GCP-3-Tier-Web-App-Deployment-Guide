# 3-Tier Web Application on Google Cloud Platform

A comprehensive guide for deploying a scalable, secure 3-tier web application architecture on Google Cloud Platform (GCP). This project demonstrates cloud infrastructure best practices using GCP services equivalent to AWS patterns (ALB, EC2, RDS).

## 🏗️ Architecture Overview

This guide implements a classic 3-tier architecture with proper network segmentation and security controls:

- **Web Tier**: Public-facing Nginx web servers behind a load balancer
- **App Tier**: Private Node.js/Express application servers for business logic
- **Data Tier**: Private Cloud SQL PostgreSQL database

```
Internet → Load Balancer → Web Tier → App Tier → Database Tier
```

## 📋 Prerequisites

Before starting, ensure you have:

- **GCP Project**: Active project with billing enabled
- **gcloud CLI**: Installed and authenticated (`gcloud init`)
- **GitHub Repository**: Public repo with your `server.js` and `package.json` files
- **APIs Enabled**: Required GCP APIs

```bash
gcloud services enable compute.googleapis.com sqladmin.googleapis.com
```

## 🚀 Deployment Guide

### Phase 1: Networking Foundation

#### 1.1 Create VPC Network

```bash
gcloud compute networks create my-app-vpc --subnet-mode=custom
```

**Console Alternative**: VPC network → VPC networks → Create VPC network

#### 1.2 Create Tier Subnets

```bash
# Web Tier Subnet (Public)
gcloud compute networks subnets create web-subnet \
    --network=my-app-vpc \
    --range=10.0.1.0/24 \
    --region=us-central1

# App Tier Subnet (Private)
gcloud compute networks subnets create app-subnet \
    --network=my-app-vpc \
    --range=10.0.2.0/24 \
    --region=us-central1

# Data Tier Subnet (Private)
gcloud compute networks subnets create data-subnet \
    --network=my-app-vpc \
    --range=10.0.3.0/24 \
    --region=us-central1
```

#### 1.3 Configure Firewall Rules

```bash
# Allow HTTP/HTTPS to Web Tier
gcloud compute firewall-rules create allow-http-https-web \
    --network=my-app-vpc \
    --allow=tcp:80,tcp:443 \
    --source-ranges=0.0.0.0/0 \
    --target-tags=web-server

# Allow SSH for management
gcloud compute firewall-rules create allow-ssh-web \
    --network=my-app-vpc \
    --allow=tcp:22 \
    --source-ranges=0.0.0.0/0 \
    --target-tags=web-server

# Allow Web Tier to App Tier communication
gcloud compute firewall-rules create allow-web-to-app \
    --network=my-app-vpc \
    --allow=tcp:3000 \
    --source-tags=web-server \
    --target-tags=app-server

# Allow App Tier to Database communication
gcloud compute firewall-rules create allow-app-to-db \
    --network=my-app-vpc \
    --allow=tcp:5432 \
    --source-tags=app-server \
    --target-tags=db-server
```

### Phase 2: Data Tier (Cloud SQL)

#### 2.1 Create PostgreSQL Instance

```bash
# Replace [YOUR_DB_PASSWORD] and [YOUR_PROJECT_ID] with actual values
gcloud sql instances create my-app-db \
    --database-version=POSTGRES_13 \
    --tier=db-n1-standard-1 \
    --region=us-central1 \
    --root-password="[YOUR_DB_PASSWORD]" \
    --network=projects/[YOUR_PROJECT_ID]/global/networks/my-app-vpc \
    --no-assign-ip
```

#### 2.2 Get Database Private IP

```bash
gcloud sql instances describe my-app-db --format='get(ipAddresses[0].ipAddress)'
```

**Note**: Save this IP address for the next phase!

### Phase 3: Application Tier

#### 3.1 Create App Startup Script

Create `app-startup.sh`:

```bash
#!/bin/bash
# Update and install dependencies
sudo apt-get update
sudo apt-get install -y git nodejs npm

# Clone your repository
git clone https://github.com/[YOUR_USERNAME]/[YOUR_REPO_NAME].git /app

# Install app dependencies
cd /app
npm install

# Create systemd service
cat <<EOF > /etc/systemd/system/myapp.service
[Unit]
Description=My 3-Tier App
After=network.target

[Service]
User=root
WorkingDirectory=/app
ExecStart=/usr/bin/node server.js
Restart=always
Environment="DB_HOST=[YOUR_DB_PRIVATE_IP]"

[Install]
WantedBy=multi-user.target
EOF

# Enable and start the service
systemctl enable myapp.service
systemctl start myapp.service
```

> ⚠️ **Important**: Replace placeholders with your actual values:
> - `[YOUR_USERNAME]/[YOUR_REPO_NAME]`
> - `[YOUR_DB_PRIVATE_IP]`

#### 3.2 Deploy App Server

```bash
gcloud compute instances create app-server-1 \
    --zone=us-central1-a \
    --machine-type=e2-medium \
    --network-interface=subnet=app-subnet,no-address \
    --tags=app-server \
    --metadata-from-file=startup-script=app-startup.sh
```

### Phase 4: Web Tier & Load Balancer

#### 4.1 Create Web Startup Script

Create `web-startup.sh`:

```bash
#!/bin/bash
# Update and install Nginx
sudo apt-get update
sudo apt-get install -y nginx

# Start Nginx
systemctl start nginx
```

#### 4.2 Create Instance Template

```bash
gcloud compute instance-templates create web-server-template \
    --machine-type=e2-small \
    --region=us-central1 \
    --network=my-app-vpc \
    --subnet=web-subnet \
    --tags=web-server \
    --metadata-from-file=startup-script=web-startup.sh
```

#### 4.3 Create Managed Instance Group

```bash
gcloud compute instance-groups managed create web-server-group \
    --template=web-server-template \
    --size=2 \
    --zone=us-central1-a
```

#### 4.4 Configure Load Balancer

```bash
# Create health check
gcloud compute health-checks create http http-basic-check --port 80

# Create backend service
gcloud compute backend-services create web-backend-service \
    --protocol=HTTP \
    --health-checks=http-basic-check \
    --global

# Add instance group to backend service
gcloud compute backend-services add-backend web-backend-service \
    --instance-group=web-server-group \
    --instance-group-zone=us-central1-a \
    --global

# Create URL map
gcloud compute url-maps create web-url-map \
    --default-service web-backend-service

# Create HTTP proxy
gcloud compute target-http-proxies create http-lb-proxy \
    --url-map=web-url-map

# Create forwarding rule (public IP)
gcloud compute forwarding-rules create http-forwarding-rule \
    --address-name=lb-ipv4-1 \
    --global \
    --target-http-proxy=http-lb-proxy \
    --ports=80
```

## 🧪 Testing Your Deployment

### Get Load Balancer IP

```bash
gcloud compute addresses describe lb-ipv4-1 --global --format="get(address)"
```

### Verify Deployment

1. Open your browser and navigate to the load balancer IP
2. You should see the "Welcome to nginx!" page
3. This confirms traffic flow: Internet → Load Balancer → Web Tier

## 🛡️ Security Features

- **Network Segmentation**: Isolated subnets for each tier
- **Firewall Rules**: Principle of least privilege access control
- **Private IPs**: App and Database tiers have no public internet access
- **Managed Services**: Cloud SQL provides built-in security and backups

## 💰 Cost Optimization

- **Right-sizing**: Uses appropriate machine types for each tier
- **Managed Services**: Reduces operational overhead
- **Auto-scaling**: MIG can scale based on demand

## 🧹 Cleanup

**Important**: Delete resources in reverse order to avoid dependency issues.

```bash
# Delete Load Balancer components
gcloud compute forwarding-rules delete http-forwarding-rule --global -q
gcloud compute target-http-proxies delete http-lb-proxy -q
gcloud compute url-maps delete web-url-map -q
gcloud compute backend-services delete web-backend-service --global -q
gcloud compute health-checks delete http-basic-check -q

# Delete MIG and Instance Template
gcloud compute instance-groups managed delete web-server-group --zone=us-central1-a -q
gcloud compute instance-templates delete web-server-template -q

# Delete VMs
gcloud compute instances delete app-server-1 --zone=us-central1-a -q

# Delete Cloud SQL
gcloud sql instances delete my-app-db -q

# Delete Firewall Rules and VPC
gcloud compute firewall-rules delete allow-http-https-web allow-ssh-web allow-web-to-app allow-app-to-db -q
gcloud compute networks subnets delete web-subnet --region=us-central1 -q
gcloud compute networks subnets delete app-subnet --region=us-central1 -q
gcloud compute networks subnets delete data-subnet --region=us-central1 -q
gcloud compute networks delete my-app-vpc -q
```

## 🚀 Next Steps

- Configure Nginx as a reverse proxy to forward requests to the app tier
- Implement HTTPS with SSL certificates
- Set up monitoring and alerting
- Add auto-scaling policies
- Implement CI/CD pipeline

## 📚 Resources

- [Google Cloud Documentation](https://cloud.google.com/docs)
- [GCP Well-Architected Framework](https://cloud.google.com/architecture/framework)
- [Cloud SQL Best Practices](https://cloud.google.com/sql/docs/postgres/best-practices)

---

**Built with ❤️ for learning cloud architecture patterns**