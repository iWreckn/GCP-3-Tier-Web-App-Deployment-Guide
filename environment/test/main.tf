# This is the main entrypoint for the 'test' environment.
# It assembles the infrastructure by calling the reusable modules we build
# and passing the environment-specific variables to them.

provider "google" {
  project = var.project_id
  region  = var.region
}

# ------------------------------------------------------------------------------
# MODULES
# ------------------------------------------------------------------------------

# Call the networking module to build our VPC, subnets, and firewalls.
module "network_security" {
  # This tells Terraform where to find the module's code.
  source = "../../modules/01.01-terraform-variables"

  # Pass variables from our root module into the child module.
  project_id  = var.project_id
  region      = var.region
  environment = var.environment
  vpc_name    = var.vpc_name
}

# Call the IAM module to create our service accounts.
module "iam_security" {
  source = "../../modules/02-iam-security"

  # Pass required variables
  project_id  = var.project_id
  environment = var.environment
}
