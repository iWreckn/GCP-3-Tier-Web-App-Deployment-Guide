terraform {
  backend "gcs" {
    # Replace this with the name of the GCS bucket you create for storing state files.
    # This bucket must exist before you run 'terraform init'.
    bucket = "gcs-3tapp"

    # This prefix creates a "folder" within the bucket specifically for the dev
    # environment's state. This is CRITICAL for isolating it from other
    # environments like 'prod'.
    prefix = "test/3-tier-app-state"
  }
}