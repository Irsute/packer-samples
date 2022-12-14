variable "vm_name" {
  type    = string
  default = "debian11-libvirt"
}
variable "vm_cpu" {
  default = 2
}
variable "vm_mem" {
  default = 2048
}
variable "vm_disk" {
  type    = string
  default = "10G"
}
variable "debian_version" {
  type    = string
  default = "debian-11.5.0-amd64"
}
variable "iso_checksum" {
  type    = string
  default = "a764f7608704beec26cc58e7323c39cc"
}
variable "config_file" {
  type    = string
  default = "debian-preseed.cfg"
}

source "qemu" "debian11" {
  accelerator      = "kvm"
  cpus             = var.vm_cpu
  memory           = var.vm_mem
  disk_size        = var.vm_disk
  net_device       = "virtio-net"
  disk_interface   = "virtio"
  format           = "qcow2"
  http_directory   = "http/"
  boot_command     = ["<esc><wait>", "auto <wait>", "console-keymaps-at/keymap=fr <wait>", "console-setup/ask_detect=false <wait>", "debconf/frontend=noninteractive <wait>", "debian-installer=en_US <wait>", "fb=false <wait>", "install <wait>", "kbd-chooser/method=fr <wait>", "keyboard-configuration/xkb-keymap=fr <wait>", "locale=en_US <wait>", "netcfg/get_hostname=${var.vm_name} <wait>", "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/${var.config_file} <wait>", "<enter><wait>"]
  iso_checksum     = var.iso_checksum
  iso_urls         = ["iso/${var.debian_version}-netinst.iso", "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/${var.debian_version}-netinst.iso"]
  shutdown_command = "echo 'vagrant' | sudo -S shutdown -P now"
  ssh_password     = "vagrant"
  ssh_username     = "vagrant"
  ssh_timeout      = "30m"
  output_directory = "builds/debian11/"
  vm_name          = "debian11-libvirt"
}

build {
  sources = ["source.qemu.debian11"]

  post-processors {
    post-processor "vagrant" {
      output = "builds/libvirt-debian11.box"
    }
  }
}
