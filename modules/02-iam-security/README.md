# 🔐 Module 2: Identity & Access Management (IAM)

Welcome to Module 2! With our network perimeter secured, we now turn our attention to the next critical layer: **Identity**. In the cloud, identity is the new perimeter. Here, we'll create dedicated, specialized identities for our application's components instead of using generic, overly-permissive defaults.

---

## 🎯 Module Expectation: The 'Why'

In this module, you'll learn and implement fundamental IAM security principles that are central to a **Zero Trust architecture**.

### 🔒 **Principle of Least Privilege for Identities**
Just like we only opened the necessary network ports, we will only grant the absolute minimum permissions that an identity needs to perform its function. Think of it as giving an employee a keycard that only opens the doors they need to do their job, instead of a master key to the entire building.

### 👤 **Dedicated Service Accounts** 
We will create a unique identity (a Service Account) for each tier of our application. This prevents a scenario where a single compromised identity could grant access to every part of our system. It also provides a clear audit trail.

### ⚠️ **Avoiding Default Service Accounts**
The default Compute Engine service account is convenient but comes with broad permissions (the Editor role) that are a significant security risk. We will explicitly avoid it, building our identities from the ground up with zero permissions by default.

---

## 🚀 Step-by-Step Guide: The 'How'

We'll continue working within our Terraform project. Add the following resource blocks to your `main.tf` file.

### Step 1: Create the Service Accounts

First, we define the three unique service accounts. Notice that by default, they are created with **no roles or permissions**. They are just identities waiting to be assigned a purpose.

```hcl
# Add to main.tf

# -----------------------------------------------------------------------------
# MODULE 2: IAM & SERVICE ACCOUNTS
# -----------------------------------------------------------------------------

# Service Account for the Web Tier VMs
resource "google_service_account" "web_tier_sa" {
  account_id   = "web-tier-sa"
  display_name = "Web Tier Service Account"
  description  = "Least privilege identity for web tier instances"
}

# Service Account for the App Tier VMs
resource "google_service_account" "app_tier_sa" {
  account_id   = "app-tier-sa"
  display_name = "App Tier Service Account"
  description  = "Least privilege identity for app tier instances"
}

# Service Account for a database administrator/tool
resource "google_service_account" "db_admin_sa" {
  account_id   = "db-admin-sa"
  display_name = "Database Admin Service Account"
  description  = "Identity for tools or users that need to connect to the SQL DB"
}
```

### Step 2: Grant a Specific Permission

Our `db-admin-sa` is the only identity that needs a permission right now: the ability to connect to a Cloud SQL database. Here, we bind the specific `roles/cloudsql.client` role directly to that service account at the project level.

```hcl
# Add to main.tf

# Grant the Cloud SQL Client role to the DB Admin Service Account
resource "google_project_iam_member" "db_admin_iam" {
  project = var.project_id # Using the variable from our setup
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.db_admin_sa.email}"
}
```

### Step 3: Deploy the New IAM Resources

Now, run the standard Terraform commands in your terminal to create the service accounts and apply the IAM binding.

```bash
# Review the planned changes (you should see 4 new resources to add)
terraform plan

# Apply the changes to create the service accounts and IAM binding
terraform apply
```

---

## ✅ Validation Guidance: The 'Did it Work?'

After `terraform apply` completes, let's verify our new, secure identities in the GCP Console.

### 🔍 **Check for Service Accounts:**

1. Navigate to **IAM & Admin** → **Service Accounts**
2. **Verify**: Do you see your three new accounts listed?
   - `web-tier-sa`
   - `app-tier-sa` 
   - `db-admin-sa`

### 🔒 **Verify Permissions (Least Privilege in Action):**

1. In the **IAM & Admin** → **IAM** page, click the **"Grant Access"** button *(don't worry, we're just looking)*
2. Find the **"Principals"** filter
3. **Filter by** the name of your `db-admin-sa`
   - ✅ You should see it listed with the single **"Cloud SQL Client"** role
4. **Clear that filter** and search for your `web-tier-sa`
   - ✅ What do you see? You should find that it has **no roles assigned** in the project's IAM table

> 🎯 **This is least privilege in action!** The identity exists, but it can't do anything yet. This is exactly what we want.

---

## 📊 **Security Architecture Summary**

```
🏗️ 3-Tier Application Security Model

┌─────────────────────────────────────────────────────────────┐
│                    Identity Layer                           │
├─────────────────┬─────────────────┬─────────────────────────┤
│   Web Tier      │   App Tier      │   Database Admin        │
│                 │                 │                         │
│ web-tier-sa     │ app-tier-sa     │ db-admin-sa            │
│ No permissions  │ No permissions  │ Cloud SQL Client       │
│ (Zero Trust)    │ (Zero Trust)    │ (Least Privilege)      │
└─────────────────┴─────────────────┴─────────────────────────┘
```

---

## 🔑 **Key Security Principles Applied**

| Principle | Implementation | Benefit |
|-----------|----------------|---------|
| **🔒 Least Privilege** | Each SA gets only required permissions | Minimizes blast radius |
| **👥 Identity Segregation** | Separate SA per tier | Clear audit trails |
| **⚠️ Zero Default Permissions** | All SAs start with no roles | Explicit security model |
| **🚫 No Default SAs** | Custom SAs replace defaults | Eliminates over-privileged access |

---

## 🎯 **What's Next?**

In the next module, we'll:
- 🗄️ **Create secure database instances**
- 🔐 **Apply encryption at rest and in transit**
- 🔗 **Connect our service accounts to actual resources**

---

## 📚 **Additional Resources**

- 📖 [GCP IAM Best Practices](https://cloud.google.com/iam/docs/using-iam-securely)
- 🔐 [Service Account Security](https://cloud.google.com/iam/docs/service-accounts)
- 🎯 [Principle of Least Privilege](https://cloud.google.com/blog/products/identity-security/dont-get-pwned-practicing-the-principle-of-least-privilege)

---

*🔐 Remember: In Zero Trust architecture, every identity is untrusted until proven otherwise. This module establishes that foundation!*