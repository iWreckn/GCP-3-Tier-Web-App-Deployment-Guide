terraform {
  backend "gcs" {
    #Create .tfvars file, set a variable for your GCS bucket. 
    #Replace this with the name of the GCS bucket you create for storing state files.
    # This bucket must exist before you run 'terraform init'.
    bucket = var.bucket_name

    # This prefix creates a "folder" within the bucket specifically for the dev
    # environment's state. This is CRITICAL for isolating it from other
    # environments like 'prod'.
    prefix = "prod/3-tier-app-state"
  }
}