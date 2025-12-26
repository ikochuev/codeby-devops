terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.80.0"
    }
  }
}

provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = var.yc_zone
}

# Используем существующую VPC "default"
data "yandex_vpc_network" "default" {
  name = "default"
}

# Public подсеть
resource "yandex_vpc_subnet" "public" {
  name           = "public-subnet"
  zone           = var.yc_zone
  network_id     = data.yandex_vpc_network.default.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

# Private подсеть
resource "yandex_vpc_subnet" "private" {
  name           = "private-subnet"
  zone           = var.yc_zone
  network_id     = data.yandex_vpc_network.default.id
  v4_cidr_blocks = ["192.168.20.0/24"]
}

# Outputs для передачи в config-2
output "vpc_id" {
  value = data.yandex_vpc_network.default.id
}

output "public_subnet_id" {
  value = yandex_vpc_subnet.public.id
}

output "private_subnet_id" {
  value = yandex_vpc_subnet.private.id
}
