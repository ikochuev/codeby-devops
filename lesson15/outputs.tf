# Информация о сети
output "network_id" {
  description = "ID of created VPC network"
  value       = yandex_vpc_network.network.id
}

output "network_name" {
  description = "Name of created VPC network"
  value       = yandex_vpc_network.network.name
}

# Информация о подсетях
output "created_subnets" {
  description = "Created subnets"
  value = {
    "ru-central1-a" = {
      id   = yandex_vpc_subnet.subnet_a.id
      name = yandex_vpc_subnet.subnet_a.name
      cidr = yandex_vpc_subnet.subnet_a.v4_cidr_blocks[0]
    }
    "ru-central1-b" = {
      id   = yandex_vpc_subnet.subnet_b.id
      name = yandex_vpc_subnet.subnet_b.name
      cidr = yandex_vpc_subnet.subnet_b.v4_cidr_blocks[0]
    }
  }
}

# Выводы из МОДУЛЯ 1 (vpc-data)
output "data_module_subnets" {
  description = "Subnets information from data module"
  value       = module.vpc_data.all_subnets
}

output "data_module_subnets_by_zone" {
  description = "Subnets grouped by zone from data module"
  value       = module.vpc_data.subnets_by_zone
}

# Информация о ВМ
output "vm_a_info" {
  description = "Information about VM in zone A"
  value = {
    id         = module.vm_a.vm_id
    name       = "lesson15-vm-a"
    public_ip  = module.vm_a.public_ip
    private_ip = module.vm_a.private_ip
    zone       = module.vm_a.zone
    subnet_id  = module.vm_a.subnet_id
    subnet_name = module.vm_a.subnet_name
  }
}

output "vm_b_info" {
  description = "Information about VM in zone B"
  value = {
    id         = module.vm_b.vm_id
    name       = "lesson15-vm-b"
    public_ip  = module.vm_b.public_ip
    private_ip = module.vm_b.private_ip
    zone       = module.vm_b.zone
    subnet_id  = module.vm_b.subnet_id
    subnet_name = module.vm_b.subnet_name
  }
}

# Демонстрация автоматического выбора подсетей
output "automatic_subnet_selection_demo" {
  description = "Demonstration of automatic subnet selection by zone"
  value = {
    "vm_a" = {
      requested_zone    = "ru-central1-a"
      selected_subnet_id   = module.vm_a.subnet_id
      selected_subnet_name = module.vm_a.subnet_name
      selected_subnet_zone = module.vm_a.subnet_zone
    }
    "vm_b" = {
      requested_zone    = "ru-central1-b"
      selected_subnet_id   = module.vm_b.subnet_id
      selected_subnet_name = module.vm_b.subnet_name
      selected_subnet_zone = module.vm_b.subnet_zone
    }
  }
}
