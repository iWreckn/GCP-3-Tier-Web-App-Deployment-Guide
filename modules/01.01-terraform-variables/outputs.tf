output "vpc_id" {
  description = "The ID of the VPC network."
  value       = google_compute_network.my_app_vpc.id
}

output "vpc_name" {
  description = "The name of the VPC network."
  value       = google_compute_network.my_app_vpc.name
}
