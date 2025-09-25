variable "project_id" {
  description = "The GCP project ID where resources will be created."
  type        = string
}

variable "environment" {
  description = "The name of the environment (e.g., 'test', 'prod')."
  type        = string
}

