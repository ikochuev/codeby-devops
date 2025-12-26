# Создаем VPC сеть
resource "yandex_vpc_network" "network" {
  name = "lesson15-network"
}

# Создаем подсети в разных зонах
resource "yandex_vpc_subnet" "subnet_a" {
  name           = "lesson15-subnet-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_vpc_subnet" "subnet_b" {
  name           = "lesson15-subnet-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.20.0/24"]
}

# МОДУЛЬ 1: Получаем данные о подсетях (строго data source)
module "vpc_data" {
  source = "./modules/vpc-data"
  
  # Передаем ID уже созданных подсетей
  subnet_ids = [
    yandex_vpc_subnet.subnet_a.id,
    yandex_vpc_subnet.subnet_b.id,
  ]
  
  # Явная зависимость: сначала создаем подсети
  depends_on = [
    yandex_vpc_subnet.subnet_a,
    yandex_vpc_subnet.subnet_b
  ]
}

# МОДУЛЬ 2: Создаем ВМ в зоне A
module "vm_a" {
  source = "./modules/vm"
  
  available_subnets = module.vpc_data.all_subnets
  vm_zone          = "ru-central1-a"
  image_id         = var.image_id
  ssh_public_key   = var.ssh_public_key
  vm_name          = "lesson15-vm-a"
  vm_cpu           = var.vm_cpu
  vm_memory        = var.vm_memory
  vm_disk_size     = var.vm_disk_size
  
  depends_on = [module.vpc_data]
}

# МОДУЛЬ 2: Создаем ВМ в зоне B
module "vm_b" {
  source = "./modules/vm"
  
  available_subnets = module.vpc_data.all_subnets
  vm_zone          = "ru-central1-b"
  image_id         = var.image_id
  ssh_public_key   = var.ssh_public_key
  vm_name          = "lesson15-vm-b"
  vm_cpu           = 2
  vm_memory        = 2
  vm_disk_size     = 15
  
  depends_on = [module.vpc_data]
}
