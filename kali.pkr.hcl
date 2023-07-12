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
  default = "54cf16e191c0b61334e9f6c1ce633c922398e13136d4b99723c64286b171646a"
}

variable "iso_url" {
  type    = string
  default = "https://cdimage.kali.org/kali-2022.4/kali-linux-2022.4-installer-netinst-amd64.iso"
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
  shutdown_command = "echo 'vagrant'|sudo -S shutdown -P now"
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
