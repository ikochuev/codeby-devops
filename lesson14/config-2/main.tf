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

// Используем существующую VPC по умолчанию
data "yandex_vpc_network" "default" {
  name = "default"
}

// Security Groups

// SG для публичной ВМ (SSH, HTTP, HTTPS)
resource "yandex_vpc_security_group" "public_sg" {
  name       = "public-sg"
  network_id = data.yandex_vpc_network.default.id

  ingress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = [var.my_ip]
  }

  ingress {
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

// SG для приватной ВМ (SSH и 8080)
resource "yandex_vpc_security_group" "private_sg" {
  name       = "private-sg"
  network_id = data.yandex_vpc_network.default.id

  ingress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = [var.my_ip]
  }

  ingress {
    protocol       = "TCP"
    port           = 8080
    v4_cidr_blocks = [var.my_ip]
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

// Публичная ВМ с Nginx
resource "yandex_compute_instance" "public_vm" {
  name = "public-vm"

  resources {
    cores          = 2
    core_fraction  = 100
    memory         = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
    }
  }

  network_interface {
    subnet_id          = var.public_subnet_id  // Используем подсеть из config-1
    nat                = true
    security_group_ids = [yandex_vpc_security_group.public_sg.id]
  }

  metadata = {
    ssh-keys = var.ssh_public_key
  }

  connection {
    type        = "ssh"
    host        = self.network_interface[0].nat_ip_address
    user        = "ubuntu"
    private_key = file(var.ssh_private_key_path)
    timeout     = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install -y nginx",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx"
    ]
  }
}

// Приватная ВМ
resource "yandex_compute_instance" "private_vm" {
  name = "private-vm"

  resources {
    cores          = 2
    core_fraction  = 100
    memory         = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
    }
  }

  network_interface {
    subnet_id          = var.private_subnet_id  // Используем подсеть из config-1
    security_group_ids = [yandex_vpc_security_group.private_sg.id]
  }

  metadata = {
    ssh-keys = var.ssh_public_key
  }
}

# Импорт существующей ВМ

