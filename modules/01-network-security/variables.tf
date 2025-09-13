variable "project_id" {
  description = "The GCP project ID where resources will be created."
  type        = string
}

variable "region" {
  description = "The GCP region for the network resources."
  type        = string
}

variable "environment" {
  description = "The name of the environment (e.g., 'test', 'prod')."
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC network."
  type        = string
}

variable "web_subnet_cidr" {
  description = "CIDR block for web tier subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "app_subnet_cidr" {
  description = "CIDR block for app tier subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "data_subnet_cidr" {
  description = "CIDR block for data tier subnet"
  type        = string
  default     = "10.0.3.0/24"
}