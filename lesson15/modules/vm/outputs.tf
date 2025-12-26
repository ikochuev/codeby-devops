output "vm_id" {
  description = "ID of created VM"
  value       = yandex_compute_instance.instance.id
}

output "public_ip" {
  description = "Public IP address of VM"
  value       = yandex_compute_instance.instance.network_interface[0].nat_ip_address
}

output "private_ip" {
  description = "Private IP address of VM"
  value       = yandex_compute_instance.instance.network_interface[0].ip_address
}

output "zone" {
  description = "Zone where VM was created"
  value       = yandex_compute_instance.instance.zone
}

output "subnet_id" {
  description = "ID of automatically selected subnet"
  value       = local.selected_subnet.id
}

output "subnet_name" {
  description = "Name of automatically selected subnet"
  value       = local.selected_subnet.name
}

output "subnet_zone" {
  description = "Zone of automatically selected subnet"
  value       = local.selected_subnet.zone
}
