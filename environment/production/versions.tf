# This file pins the versions of Terraform and the providers.
# Pinning versions is a best practice to ensure that your code doesn't
# break unexpectedly when a new provider version is released.

terraform {
  required_version = ">= 1.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}