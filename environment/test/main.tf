# This is the main entrypoint for the 'dev' environment.
# It assembles the infrastructure by calling the reusable modules
# and passing the environment-specific variables to them.

# Configure the Google Provider.
# The project and region values will be pulled from your terraform.tfvars file.
provider "google" {
  project = var.project_id
  region  = var.gcp_region
}

# ------------------------------------------------------------------------------
# MODULES
# ------------------------------------------------------------------------------

# Call the networking module to build our VPC, subnets, and firewalls.
module "network_security" {
  # This tells Terraform where to find the module's code.
  source = "../../modules/01-network-security"

  # Pass variables from our root module into the child module.
  # These values will likely come from your terraform.tfvars file.
  project_id = var.project_id
  gcp_region = var.gcp_region

  # You can also hardcode values if they are specific to this module call.
  vpc_name = "my-app-vpc-prod"
}

# ---
# You'll add your next module call here for IAM security.
# module "iam_security" {
#   source = "../../modules/02-iam-security"
#   ...
# }
# ---
