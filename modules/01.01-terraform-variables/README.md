# 🔧 Terraform Variables: Hard-Coded vs Variable-Based Configuration

This guide explains the difference between hard-coded values and variables in Terraform, using our 3-tier GCP network infrastructure as an example.

## 🚫 Hard-Coded Configuration (Not Recommended for Production)

In a hard-coded configuration, all values are directly written into the Terraform files:

```hcl
resource "google_compute_network" "my_app_vpc" {
  name                    = "my-3tier-app-vpc"
  auto_create_subnetworks = false
  project                 = "your-project-id-here"
}

resource "google_compute_subnetwork" "web_subnet" {
  name          = "test-web-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-central1"
  network       = google_compute_network.my_app_vpc.id
  project       = "your-project-id-here"
}
```

### ⚠️ Problems with Hard-Coded Values:
- **Not reusable**: You need separate files for different environments
- **Error-prone**: Easy to forget to change values when copying between environments
- **Maintenance nightmare**: Changes require editing multiple files
- **Security risk**: Sensitive values are exposed in code

---

## ✅ Variable-Based Configuration (Recommended)

Variables make your Terraform code flexible and reusable:

```hcl
resource "google_compute_network" "my_app_vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
  project                 = var.project_id
}

resource "google_compute_subnetwork" "web_subnet" {
  name          = "${var.environment}-web-subnet"
  ip_cidr_range = var.web_subnet_cidr
  region        = var.region
  network       = google_compute_network.my_app_vpc.id
  project       = var.project_id
}
```

---

## 🔄 How Terraform Variables Work

### 1️⃣ Define Variables (`variables.tf`)

```hcl
variable "project_id" {
  description = "The Google Cloud Project ID"
  type        = string
}

variable "environment" {
  description = "Environment name (test, prod, dev)"
  type        = string
  validation {
    condition     = contains(["test", "prod", "dev"], var.environment)
    error_message = "Environment must be test, prod, or dev."
  }
}

variable "region" {
  description = "The GCP region to deploy resources"
  type        = string
  default     = "us-central1"
}
```

### 2️⃣ Provide Values (`terraform.tfvars`)

```hcl
project_id  = "my-actual-project-id"
environment = "test"
region      = "us-central1"
vpc_name    = "my-3tier-app-vpc"
```

### 3️⃣ Use Variables in Configuration (`main.tf`)

```hcl
resource "google_compute_subnetwork" "web_subnet" {
  name          = "${var.environment}-web-subnet"
  ip_cidr_range = var.web_subnet_cidr
  region        = var.region
  network       = google_compute_network.my_app_vpc.id
  project       = var.project_id
}
```

---

## 📊 Variable Types

| Type | Example | Description |
|------|---------|-------------|
| `string` | `"us-central1"` | Text values |
| `number` | `1000` | Numeric values |
| `bool` | `true` or `false` | Boolean values |
| `list(string)` | `["web-server", "app-server"]` | List of strings |
| `map(string)` | `{ env = "test", owner = "team" }` | Key-value pairs |

---

## 🎯 Variable Features

### 🔧 Default Values
Variables can have default values, making them optional:

```hcl
variable "region" {
  description = "The GCP region to deploy resources"
  type        = string
  default     = "us-central1"  # Optional - will use this if not provided
}
```

### ✅ Validation Rules
Add validation to ensure variables meet requirements:

```hcl
variable "environment" {
  description = "Environment name"
  type        = string
  validation {
    condition     = contains(["test", "prod", "dev"], var.environment)
    error_message = "Environment must be test, prod, or dev."
  }
}
```

---

## 🚀 Benefits of Using Variables

| Benefit | Description |
|---------|-------------|
| **🔄 Reusability** | Same code works for multiple environments |
| **🎯 Consistency** | Reduces human error when deploying |
| **🔒 Security** | Sensitive values can be passed securely |
| **🛠️ Maintainability** | Changes in one place affect all resources |
| **📚 Documentation** | Variable descriptions explain what each value does |

---

## 📁 Directory Structure Best Practice

```
project/
├── environments/
│   ├── test/
│   │   ├── terraform.tfvars  # Test environment values
│   │   └── main.tf           # Calls modules with variables
│   └── prod/
│       ├── terraform.tfvars  # Production environment values
│       └── main.tf           # Same code, different values
└── modules/
    └── network/
        ├── main.tf           # Resource definitions with variables
        ├── variables.tf      # Variable declarations
        └── outputs.tf        # Output declarations
```

---

## 🎮 How to Use This Project

1. **📖 For Learning**: Compare the hard-coded version with the variable version
2. **🧪 For Development**: Use the `test/` environment with your values
3. **🚀 For Production**: Copy to `prod/` environment with production values

---

## 🔥 Common Variable Patterns

### 🏷️ Environment-Based Naming

```hcl
name = "${var.environment}-${var.resource_name}"
# Results in: "test-web-subnet" or "prod-web-subnet"
```

### 🔀 Conditional Values

```hcl
instance_count = var.environment == "prod" ? 3 : 1
# 3 instances for prod, 1 for everything else
```

### 🗺️ Environment-Specific Maps

```hcl
variable "instance_types" {
  type = map(string)
  default = {
    test = "e2-micro"
    prod = "e2-standard-2"
  }
}

instance_type = var.instance_types[var.environment]
```

---

## 📈 Next Steps

1. ✅ Start with hard-coded values to understand the resources
2. 🔍 Identify values that change between environments
3. 📤 Extract those values into variables
4. ✅ Add validation rules for important variables
5. 📁 Create separate `.tfvars` files for each environment

---

## 💡 Pro Tips

> 🎯 **Remember**: Variables make your Terraform code more professional, maintainable, and less error-prone!

> 🔐 **Security**: Never commit `.tfvars` files with sensitive data to version control

> 🧪 **Testing**: Use `terraform plan` to verify your variables are working correctly

---

## 🤝 Contributing

Found an issue or want to improve this guide? 
- 🐛 [Report a bug](../../issues)
- 💡 [Suggest an enhancement](../../issues)
- 🔀 Submit a pull request

---

*🏗️ This guide is part of the 3-Tier Web Application Deployment series. Check out the other modules for complete infrastructure setup!*
