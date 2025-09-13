# 🎛️ Manual Deployment Guide: IAM & Service Accounts

This comprehensive guide walks you through manually creating the Identity & Access Management (IAM) setup in Google Cloud Platform. Each step corresponds directly to the resources defined in your Terraform IAM module.

## 📋 Overview

We'll be creating:
- **Three dedicated service accounts** with specific purposes
- **Zero Trust security model** - no default permissions
- **Least privilege access** - only the minimum required permissions
- **Clear audit trail** - dedicated identity per tier

---

## 🚀 Part 1: Navigate to Service Accounts

### Step 1: Access IAM Console
1. In the GCP Console, click the **Navigation menu (☰)** in the top-left
2. Navigate to **IAM & Admin** → **Service Accounts**

---

## 🌐 Part 2: Create Web Tier Service Account

### Step 1: Initiate Service Account Creation
1. Click **CREATE SERVICE ACCOUNT** at the top of the page

### Step 2: Configure Service Account Details
2. Fill in the service account information:
   - **Service account name:** `web-tier-sa`
   - **Service account ID:** (auto-filled as `web-tier-sa`)
   - **Description:** `Least privilege identity for web tier instances`
3. Click **CREATE AND CONTINUE**

### Step 3: Skip Permission Assignment (Zero Trust)
4. **Grant this service account access to project (Optional):**
   - ⚠️ **Important:** Click **CONTINUE** without adding any roles
   - This implements our Zero Trust principle - no permissions by default

### Step 4: Complete Creation
5. **Grant users access to this service account (Optional):**
   - Click **DONE** (skip this step)

---

## ⚙️ Part 3: Create App Tier Service Account

### Step 1: Create Second Service Account
1. Click **CREATE SERVICE ACCOUNT** again

### Step 2: Configure App Tier Details
2. Fill in the service account information:
   - **Service account name:** `app-tier-sa`
   - **Service account ID:** `app-tier-sa`
   - **Description:** `Least privilege identity for app tier instances`
3. Click **CREATE AND CONTINUE**

### Step 3: Skip Permission Assignment
4. **Grant this service account access to project:**
   - Again, click **CONTINUE** with no roles assigned
   - Another identity following Zero Trust principles

### Step 4: Complete Creation
5. Click **DONE**

---

## 🗄️ Part 4: Create Database Admin Service Account

### Step 1: Create Third Service Account
1. Click **CREATE SERVICE ACCOUNT** one more time

### Step 2: Configure Database Admin Details
2. Fill in the service account information:
   - **Service account name:** `db-admin-sa`
   - **Service account ID:** `db-admin-sa`
   - **Description:** `Identity for tools or users that need to connect to the SQL DB`
3. Click **CREATE AND CONTINUE**

### Step 3: Assign Specific Permission (Least Privilege)
4. **Grant this service account access to project:**
   - **This time we WILL add a role** (the only one that needs permissions)
   - Click **Add Another Role**
   - In the **Select a role** dropdown, search for: `Cloud SQL Client`
   - Navigate to **Cloud SQL** → **Cloud SQL Client**
   - Select this role
5. Click **CONTINUE**

### Step 4: Complete Creation
6. Click **DONE**

---

## ✅ Part 5: Verification & Security Validation

### Step 1: Verify All Service Accounts Exist
1. Back on the Service Accounts page, confirm you see three new accounts:
   - `web-tier-sa@your-project.iam.gserviceaccount.com`
   - `app-tier-sa@your-project.iam.gserviceaccount.com`
   - `db-admin-sa@your-project.iam.gserviceaccount.com`

### Step 2: Verify Least Privilege Implementation
1. Navigate to **IAM & Admin** → **IAM**
2. **Test Database Admin Permissions:**
   - In the **Filter** box, type `db-admin-sa`
   - ✅ **Expected Result:** Shows "Cloud SQL Client" role
   - This confirms our database admin has exactly one permission

### Step 3: Verify Zero Trust for Other Accounts
3. **Clear the filter** and search for `web-tier-sa`
   - ✅ **Expected Result:** No entries found in IAM table
   - This confirms zero permissions (Zero Trust implemented)

4. **Search for** `app-tier-sa`
   - ✅ **Expected Result:** No entries found in IAM table
   - Another confirmation of Zero Trust principles

---

## 🔒 Security Architecture Summary

```
🏗️ Zero Trust Identity Model

┌─────────────────────────────────────────────────────────────┐
│                    Service Account Layer                    │
├─────────────────┬─────────────────┬─────────────────────────┤
│   Web Tier      │   App Tier      │   Database Admin        │
│                 │                 │                         │
│ web-tier-sa     │ app-tier-sa     │ db-admin-sa            │
│ ✅ No permissions│ ✅ No permissions│ ✅ Cloud SQL Client only │
│ (Zero Trust)    │ (Zero Trust)    │ (Least Privilege)      │
└─────────────────┴─────────────────┴─────────────────────────┘
```

---

## 📊 Final Validation Checklist

### Service Account Creation
- [ ] `web-tier-sa` exists with zero permissions
- [ ] `app-tier-sa` exists with zero permissions
- [ ] `db-admin-sa` exists with Cloud SQL Client role only

### Security Principles Implemented
- [ ] **Zero Trust:** Two accounts have no default permissions
- [ ] **Least Privilege:** Database admin has only required permission
- [ ] **Identity Segregation:** Separate account per application tier
- [ ] **No Default Accounts:** Custom accounts replace generic defaults

---

## 🎯 What We've Accomplished

| Security Principle | Implementation | Benefit |
|-------------------|----------------|---------|
| **🔒 Zero Trust** | Service accounts created with no default permissions | Eliminates over-privileged access |
| **🎯 Least Privilege** | Only db-admin-sa gets specific required role | Minimizes attack surface |
| **👥 Identity Segregation** | Unique service account per tier | Clear audit trails and isolation |
| **🚫 Default Account Avoidance** | Custom accounts replace generic defaults | Reduces security risks |

---

## 📈 Next Steps

Once your IAM setup is complete, you can:
1. **Attach these service accounts** to compute instances in each tier
2. **Create additional custom roles** if needed for specific permissions
3. **Implement service account keys** for external authentication
4. **Set up monitoring** for service account usage

---

*🔐 This guide implements Zero Trust architecture principles where every identity starts with zero permissions and earns only what's necessary.*