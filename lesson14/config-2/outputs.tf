output "public_vm_ip" {
  description = "Публичный IP-адрес публичной ВМ"
  value       = yandex_compute_instance.public_vm.network_interface[0].nat_ip_address
}

output "private_vm_internal_ip" {
  description = "Внутренний IP-адрес приватной ВМ"
  value       = yandex_compute_instance.private_vm.network_interface[0].ip_address
}
