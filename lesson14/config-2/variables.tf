variable "service_account_key_file" {
  description = "Путь к файлу ключа сервисного аккаунта"
  type        = string
}

variable "yc_cloud_id" {
  description = "ID облака"
  type        = string
}

variable "yc_folder_id" {
  description = "ID каталога"
  type        = string
}

variable "yc_zone" {
  description = "Зона доступности"
  type        = string
  default     = "ru-central1-a"
}

variable "my_ip" {
  description = "Ваш публичный IP для доступа (например, 5.227.31.62/32)"
  type        = string
}

variable "image_id" {
  description = "ID образа для ВМ (например, Ubuntu)"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH‑ключ для доступа к ВМ"
  type        = string
}

variable "ssh_private_key_path" {
  description = "Путь к приватному SSH‑ключу для provisioner"
  type        = string
}

variable "public_subnet_id" {
  description = "Public subnet ID from config-1"
  type        = string
}

variable "private_subnet_id" {
  description = "Private subnet ID from config-1"
  type        = string
}
