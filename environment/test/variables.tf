variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "us-south1"
}

variable "environment" {
  description = "Environment name (test, production)"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}