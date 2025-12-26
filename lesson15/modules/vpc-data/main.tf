terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

variable "subnet_ids" {
  description = "List of subnet IDs to get information about"
  type        = list(string)
}

# Получаем информацию о КАЖДОЙ подсети по её ID
data "yandex_vpc_subnet" "subnet_data" {
  count = length(var.subnet_ids)
  subnet_id = var.subnet_ids[count.index]
}

locals {
  # Создаем список объектов подсетей
  all_subnets_list = [
    for subnet in data.yandex_vpc_subnet.subnet_data : {
      id   = subnet.id
      name = subnet.name
      zone = subnet.zone
      cidr = length(subnet.v4_cidr_blocks) > 0 ? subnet.v4_cidr_blocks[0] : null
    }
  ]
  
  # Группируем подсети по зонам
  subnets_by_zone = {
    for subnet in local.all_subnets_list :
    subnet.zone => subnet...
  }
}
