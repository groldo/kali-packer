variable "boot_wait" {
  type    = string
  default = "5s"
}

variable "disk_size" {
  type    = string
  default = "40960"
}

variable "iso_checksum" {
  type    = string
  default = "0b0f5560c21bcc1ee2b1fef2d8e21dca99cc6efa938a47108bbba63bec499779"
}

variable "iso_url" {
  type    = string
  default = "https://cdimage.kali.org/kali-2023.3/kali-linux-2023.3-installer-netinst-amd64.iso"
}

variable "username" {
  type    = string
  default = "user"
}

variable "vm_name" {
  type    = string
  default = "kali-rolling"
}

variable "output_directory" {
  type    = string
  default = "output"
}

source "vmware-iso" "kali" {
  boot_command     = ["<esc><wait>",
                        "install preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg debian-installer=en_US auto locale=en_US kbd-chooser/method=us <wait>",
                        "netcfg/get_hostname={{ .Name }} netcfg/get_domain=local fb=false debconf/frontend=noninteractive console-setup/ask_detect=false <wait>",
                        "console-keymaps-at/keymap=us keyboard-configuration/xkb-keymap=us <wait>",
                        "<enter><wait>"]
  boot_wait        = "${var.boot_wait}"
  disk_size        = "${var.disk_size}"
  disk_type_id     = "0"
  guest_os_type    = "debian10-64"
  headless         = false
  http_content     = {
    "/preseed.cfg"  = templatefile("${path.root}/http/preseed.cfg", {"user" = "${var.username}"})
  }
  iso_checksum     = "${var.iso_checksum}"
  iso_url          = "${var.iso_url}"
  shutdown_command = "echo '${var.username}'|sudo -S shutdown -P now"
  ssh_username     = "${var.username}"
  ssh_password     = "${var.username}"
  ssh_port         = 22
  ssh_timeout      = "60m"
  vm_name          = "${var.vm_name}"
  memory	   = "1024"
  cpus	           = "1"
  vmx_data = {
    "virtualHW.version" = "14"
  }
  output_directory = "${var.output_directory}"
}

build {
  sources = ["source.vmware-iso.kali"]
}
