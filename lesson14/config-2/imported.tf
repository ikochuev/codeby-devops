resource "yandex_compute_instance" "imported_vm" {
  name = "imported-manual-vm"
  zone = "ru-central1-a"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 100
  }

  boot_disk {
    initialize_params {
      image_id = "fd8498pb5smsd5ch4gid"
      size     = 8  # Фактический размер диска
    }
  }

  network_interface {
    subnet_id = "e9b5uolc3til3q3ubhod"
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDhZIXdF+nQj3b97hRZ3n5szi/iqE9oUSHoc+MdxRFTsWruIksaWHnepdh446KrjBfNAQxta5EF5qiTu3Pbz58L9LbHZDW73c99z3rG/UEM2QgKElvZAJkvceYms/G04fnjTrzDPi7tvqcrb8p1DikiifUdMquaSf9J7SOaB4lqf1S9cVbsBEp9Pu+hZ2Db+4jRy1XgY3fYkuAiTLk7ZxYV9tqvGs+zVhuD7H6/Qcp84C0lTk7/lW1wCBuK1MFMCBEFJS2Vs1WFksvNN+6refYLTjrITZQOZ6RgHfP7QC1xNHnz3sbuN9g6jKXXxafBXvmF1EGM3KCcR6JEfQcStnEQkkaERLDOj3lNc93IZSkkjrb3uAVSdcD48WmxpGs5WUm8wNRCSO/73fW5QEm2dgLlrRjLeF6cVDAMJ3KRDW2hl8flw5A8b6pGBV/lGXbEmevT9BN1d3wSg707wGrE2pTHUjMEuQmreRFrTLQEs1aAoKwtEEmHKaHpgODsnMKEoc= user@user-VMware-Virtual-Platform"
  }

  platform_id = "standard-v1"
}
