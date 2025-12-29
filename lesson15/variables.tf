variable "service_account_key_file" {
  description = "Path to Yandex.Cloud service account key file"
  type        = string
}

variable "yc_cloud_id" {
  description = "Yandex.Cloud cloud ID"
  type        = string
}

variable "yc_folder_id" {
  description = "Yandex.Cloud folder ID"
  type        = string
}

variable "yc_zone" {
  description = "Yandex.Cloud default zone for provider"
  type        = string
  default     = "ru-central1-a"
}

variable "image_id" {
  description = "Image ID for VM"
  type        = string
  default     = "fd8498pb5smsd5ch4gid"
}

variable "ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string
}

variable "vm_zone" {
  description = "Zone for creating VM"
  type        = string
  default     = "ru-central1-a"
}

variable "vm_name" {
  description = "Name for VM"
  type        = string
  default     = "lesson15-vm"
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
