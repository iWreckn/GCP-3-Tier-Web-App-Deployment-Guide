# Module 3: Data Security - Console Walkthrough

This guide walks you through verifying your Module 3 data security implementation using the Google Cloud Console. Follow these steps to ensure all security controls are properly configured.

## 🎯 Overview

After running `terraform apply` for Module 3, you should have:
- ✅ Cloud SQL PostgreSQL instance with private networking
- ✅ Application database and secure users
- ✅ Cloud Storage bucket with security controls
- ✅ Secret Manager secrets for credentials
- ✅ Monitoring alerts and audit logging
- ✅ Firewall rules for database access

## 🗄️ Part 1: Verify Cloud SQL Database Security

### **Step 1: Check Database Instance Configuration**

1. **Navigate to Cloud SQL**
   - In the GCP Console, go to **SQL** (or search "SQL" in the top search bar)
   - You should see your database instance: `[environment]-secure-postgres-db`

2. **Verify Instance Security Settings**
   - Click on your database instance name
   - **Instance ID**: Should be `[environment]-secure-postgres-db`
   - **Database version**: Should show `PostgreSQL 15` (or your specified version)
   - **Region**: Should match your configured region

3. **Check Network Security (Critical)**
   - Click on the **Connections** tab
   - **Public IP**: Should show "Not configured" ✅
   - **Private IP**: Should show an internal IP address (10.x.x.x) ✅
   - **Authorized networks**: Should be empty or show only your admin IPs ✅

   > 🚨 **Security Alert**: If you see a public IP configured, your database is exposed to the internet!

### **Step 2: Verify Backup and Recovery Configuration**

1. **Check Backup Settings**
   - In your database instance, click **Backups**
   - **Automated backups**: Should be "Enabled" ✅
   - **Backup window**: Should show "03:00" (3 AM) ✅
   - **Point-in-time recovery**: Should be "Enabled" ✅

2. **Verify Backup Retention**
   - **Backup retention**: Should show 7 days (dev/test) or 30 days (prod) ✅
   - **Transaction log retention**: Should show 7 days ✅

### **Step 3: Check Database Security Flags**

1. **Navigate to Database Flags**
   - In your database instance, click **Edit**
   - Scroll down to **Flags** section
   - Verify these security flags are set:
     - `log_connections`: **on** ✅
     - `log_disconnections`: **on** ✅
     - `log_checkpoints`: **on** ✅
     - `log_lock_waits`: **on** ✅

2. **Check Maintenance Window**
   - **Maintenance window**: Should show "Sunday, 04:00" ✅
   - **Update track**: Should show "stable" ✅

## 👤 Part 2: Verify Database Users and Permissions

### **Step 1: Check Database Users**

1. **Navigate to Users**
   - In your database instance, click **Users**
   - You should see these users:
     - `appuser` (your application user) ✅
     - `appuser_readonly` (read-only user) ✅
     - `postgres` (default admin user) ✅

2. **Verify User Configuration**
   - Click on `appuser`
   - **Host**: Should show "%" (any host within VPC) ✅
   - **Password**: Should be set (not visible for security) ✅

### **Step 2: Check Database Creation**

1. **Navigate to Databases**
   - In your database instance, click **Databases**
   - You should see:
     - `appdb` (your application database) ✅
     - `postgres` (default system database) ✅

2. **Verify Database Settings**
   - Click on `appdb`
   - **Charset**: Should show "UTF8" ✅
   - **Collation**: Should show "en_US.UTF8" ✅

## 🪣 Part 3: Verify Cloud Storage Security

### **Step 1: Check Storage Bucket Configuration**

1. **Navigate to Cloud Storage**
   - Go to **Cloud Storage** → **Buckets**
   - Find your bucket: `[project-id]-[environment]-app-data`

2. **Verify Bucket Security Settings**
   - Click on your bucket name
   - **Location**: Should match your region ✅
   - **Storage class**: Should show "Standard" ✅
   - **Public access**: Should show "Not public" ✅

3. **Check Access Control**
   - Click **Permissions** tab
   - **Uniform bucket-level access**: Should be "Enabled" ✅
   - Verify only your service accounts have access ✅

### **Step 2: Verify Bucket Features**

1. **Check Versioning**
   - In bucket details, look for **Object Versioning**
   - Should show "Enabled" ✅

2. **Check Lifecycle Management**
   - Click **Lifecycle** tab
   - Should show a rule to delete objects after 30-90 days ✅

3. **Check Encryption**
   - Click **Configuration** tab
   - **Encryption**: Should show "Google-managed key" or your KMS key ✅

## 🔑 Part 4: Verify Secret Manager Configuration

### **Step 1: Check Secret Creation**

1. **Navigate to Secret Manager**
   - Go to **Security** → **Secret Manager**
   - You should see: `[environment]-db-connection-string` ✅

2. **Verify Secret Configuration**
   - Click on your secret name
   - **Replication**: Should show your region ✅
   - **Versions**: Should show "1 version" ✅

3. **Check Secret Access**
   - Click **Permissions** tab
   - Your app service account should have "Secret Manager Secret Accessor" role ✅

### **Step 2: Test Secret Access (Optional)**

```bash
# Test secret access (run from Cloud Shell or authenticated environment)
gcloud secrets versions access latest --secret="[environment]-db-connection-string"
```

Expected output: A PostgreSQL connection string (credentials will be masked)

## 🔥 Part 5: Verify Firewall Rules

### **Step 1: Check Database Firewall Rules**

1. **Navigate to VPC Firewall**
   - Go to **VPC network** → **Firewall**
   - Filter by your VPC network name

2. **Verify Database Access Rules**
   - Look for: `[environment]-allow-app-to-database`
     - **Direction**: Ingress ✅
     - **Action**: Allow ✅
     - **Targets**: Specified target tags (database-server) ✅
     - **Source tags**: app-server ✅
     - **Protocols and ports**: TCP:5432 ✅

3. **Check Admin Access Rule**
   - Look for: `[environment]-allow-admin-to-database`
     - **Source IP ranges**: Your admin IP addresses ✅
     - **Protocols and ports**: TCP:5432 ✅
     - **Logs**: Should be enabled ✅

## 📊 Part 6: Verify Monitoring and Alerting

### **Step 1: Check Alert Policies**

1. **Navigate to Monitoring**
   - Go to **Monitoring** → **Alerting**
   - You should see: `[environment] Database Connection Alert` ✅

2. **Verify Alert Configuration**
   - Click on the alert policy
   - **Condition**: Database connection count ✅
   - **Threshold**: Your configured maximum connections ✅
   - **Duration**: 300 seconds (5 minutes) ✅

### **Step 2: Check Monitoring Dashboards**

1. **Navigate to Metrics Explorer**
   - Go to **Monitoring** → **Metrics Explorer**
   - Search for "Cloud SQL" metrics
   - You should see data for your database instance ✅

2. **Verify Key Metrics**
   - **Database connections**: Should show current connection count
   - **CPU utilization**: Should show database CPU usage
   - **Memory utilization**: Should show database memory usage

## 📝 Part 7: Verify Audit Logging

### **Step 1: Check Log Sink Configuration**

1. **Navigate to Logging**
   - Go to **Logging** → **Logs Router**
   - You should see: `[environment]-database-audit-sink` ✅

2. **Verify Sink Configuration**
   - Click on the sink name
   - **Destination**: Should point to your storage bucket ✅
   - **Filter**: Should include Cloud SQL and GCS resources ✅

### **Step 2: Check Audit Logs**

1. **Navigate to Logs Explorer**
   - Go to **Logging** → **Logs Explorer**
   - Use this filter: `resource.type="cloudsql_database"`

2. **Verify Log Entries**
   - You should see database connection logs ✅
   - Look for entries with your database instance name ✅

## 🔍 Part 8: Security Validation Tests

### **Test 1: Verify No Public Database Access**

```bash
# This should FAIL (no public IP configured)
psql -h [PUBLIC_IP] -U appuser -d appdb
# Expected: Connection timeout or "could not connect" error ✅
```

### **Test 2: Verify Private Network Access**

```bash
# From a VM in the same VPC, this should work
psql -h [PRIVATE_IP] -U appuser -d appdb
# Expected: Password prompt and successful connection ✅
```

### **Test 3: Verify Service Account Access to Secrets**

```bash
# Test secret access with proper authentication
gcloud secrets versions access latest --secret="[environment]-db-connection-string"
# Expected: Connection string returned ✅
```

### **Test 4: Verify Storage Bucket Access**

```bash
# Test bucket access
gsutil ls gs://[project-id]-[environment]-app-data/
# Expected: Bucket contents listed (may be empty) ✅
```

## ✅ Security Validation Checklist

Use this checklist to ensure all security controls are properly configured:

### **Database Security**
- [ ] Database has no public IP address
- [ ] Database is on private network only
- [ ] Automated backups are enabled
- [ ] Point-in-time recovery is enabled
- [ ] Security logging flags are enabled
- [ ] Deletion protection is enabled (for prod)

### **Access Controls**
- [ ] Application user has minimal required permissions
- [ ] Read-only user exists for reporting
- [ ] Service accounts have appropriate IAM roles
- [ ] Admin access is restricted to specific IP ranges

### **Data Protection**
- [ ] Encryption at rest is enabled
- [ ] Encryption in transit is enforced
- [ ] Storage bucket has uniform access control
- [ ] Object versioning is enabled
- [ ] Lifecycle management is configured

### **Monitoring and Compliance**
- [ ] Database connection alerts are configured
- [ ] Audit logging is enabled and working
- [ ] Log sink is properly configured
- [ ] Monitoring dashboards show database metrics

### **Network Security**
- [ ] Firewall rules restrict database access
- [ ] Only app tier can connect to database
- [ ] Admin access is logged and restricted
- [ ] No unnecessary network exposure

## 🚨 Common Issues and Troubleshooting

### **Issue: Database Connection Fails**
**Symptoms**: Cannot connect to database from application
**Check**:
1. Verify private IP is configured
2. Check firewall rules allow app-to-database traffic
3. Confirm service networking connection is established
4. Verify database user credentials

### **Issue: Secret Access Denied**
**Symptoms**: Cannot retrieve secrets from Secret Manager
**Check**:
1. Verify service account has Secret Manager Secret Accessor role
2. Check secret exists in correct project
3. Confirm authentication is working

### **Issue: Storage Bucket Access Denied**
**Symptoms**: Cannot read/write to storage bucket
**Check**:
1. Verify service account has appropriate storage roles
2. Check bucket IAM permissions
3. Confirm uniform bucket-level access is enabled

### **Issue: No Monitoring Data**
**Symptoms**: Monitoring dashboards show no data
**Check**:
1. Verify monitoring API is enabled
2. Check database instance is running
3. Confirm alert policies are properly configured

## 🎯 Next Steps

Once you've verified all components are working correctly:

1. **Document Your Configuration**: Note any customizations for your environment
2. **Test Application Connectivity**: Ensure your applications can connect to the database
3. **Review Security Posture**: Confirm all security controls meet your requirements
4. **Prepare for Module 4**: Infrastructure hardening and compute security

## 📞 Getting Help

If you encounter issues during verification:

1. **Check Terraform Output**: Review any error messages from `terraform apply`
2. **Verify Prerequisites**: Ensure Modules 1 and 2 are properly deployed
3. **Review IAM Permissions**: Confirm your account has necessary permissions
4. **Check API Enablement**: Verify all required APIs are enabled

---

**🔒 Security Note**: This console walkthrough helps you verify that enterprise-grade security controls are properly implemented. Each check ensures your data layer meets production security standards and compliance requirements.
