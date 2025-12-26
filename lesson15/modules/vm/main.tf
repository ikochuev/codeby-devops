terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

# Переменные модуля - ВСЕ ОДИН РАЗ
variable "available_subnets" {
  description = "List of available subnet objects"
  type = list(object({
    id   = string
    name = string
    zone = string
    cidr = string
  }))
}

variable "vm_zone" {
  description = "Zone for creating VM"
  type        = string
}

variable "image_id" {
  description = "Image ID for VM"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string
}

variable "vm_name" {
  description = "Name for the virtual machine"
  type        = string
  default     = "terraform-vm"
}

variable "vm_cpu" {
  description = "Number of CPU cores"
  type        = number
  default     = 2
}

variable "vm_memory" {
  description = "Amount of memory in GB"
  type        = number
  default     = 2
}

variable "vm_disk_size" {
  description = "Boot disk size in GB"
  type        = number
  default     = 20
}

# Находим первую подсеть в запрошенной зоне
locals {
  selected_subnet = one([
    for subnet in var.available_subnets : subnet
    if subnet.zone == var.vm_zone
  ])
}

# Создаем ВМ
resource "yandex_compute_instance" "instance" {
  name        = var.vm_name
  platform_id = "standard-v3"
  zone        = var.vm_zone

  resources {
    cores  = var.vm_cpu
    memory = var.vm_memory
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = var.vm_disk_size
    }
  }

  network_interface {
    subnet_id = local.selected_subnet.id  # Автоматический выбор!
    nat       = true
  }

  metadata = {
    ssh-keys = var.ssh_public_key
  }
}
