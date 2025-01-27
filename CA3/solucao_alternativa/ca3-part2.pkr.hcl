variable "cpus" {
  type    = string
  default = "1"
}

variable "disk_size" {
  type    = string
  default = "40960"
}

variable "headless" {
  type    = string
  default = "true"
}

variable "hostname" {
  type    = string
  default = "ubuntu"
}

variable "http_proxy" {
  type    = string
  default = "${env("http_proxy")}"
}

variable "https_proxy" {
  type    = string
  default = "${env("https_proxy")}"
}

variable "iso_checksum" {
  type    = string
  default = "f5cbb8104348f0097a8e513b10173a07dbc6684595e331cb06f93f385d0aecf6"
}

variable "iso_checksum_type" {
  type    = string
  default = "sha256"
}

variable "iso_name" {
  type    = string
  default = "ubuntu-18.04.5-server-amd64.iso"
}

variable "iso_path" {
  type    = string
  default = "iso"
}

variable "iso_url" {
  type    = string
  default = "http://cdimage.ubuntu.com/releases/18.04/release/ubuntu-18.04.6-server-amd64.iso"
}

variable "memory" {
  type    = string
  default = "1024"
}

variable "no_proxy" {
  type    = string
  default = "${env("no_proxy")}"
}

variable "preseed" {
  type    = string
  default = "preseed.cfg"
}

variable "ssh_fullname" {
  type    = string
  default = "ubuntu"
}

variable "ssh_password" {
  type    = string
  default = "ubuntu"
}

variable "ssh_username" {
  type    = string
  default = "ubuntu"
}

variable "update" {
  type    = string
  default = "true"
}

variable "version" {
  type    = string
  default = "0.1"
}

variable "virtualbox_guest_os_type" {
  type    = string
  default = "Ubuntu_64"
}

variable "vm_name_1" {
  type    = string
  default = "server"
}

variable "vm_name_2" {
  type    = string
  default = "h2"
}

variable "home" {
  type    = string
  default = env("USERPROFILE")
}


source "virtualbox-iso" "CA3" {
  boot_command            = [
    "<esc><esc><enter><wait>", 
    "/install/vmlinuz noapic ", 
    "initrd=/install/initrd.gz ", 
    "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/${var.preseed} ", 
    "debian-installer=en_US auto locale=en_US kbd-chooser/method=us ", 
    "hostname=${var.hostname} ", 
    "grub-installer/bootdev=/dev/sda<wait> ", 
    "fb=false debconf/frontend=noninteractive ", 
    "keyboard-configuration/modelcode=SKIP keyboard-configuration/layout=USA ", 
    "keyboard-configuration/variant=USA console-setup/ask_detect=false ", 
    "passwd/user-fullname=${var.ssh_fullname} ", 
    "passwd/user-password=${var.ssh_password} ", 
    "passwd/user-password-again=${var.ssh_password} ", 
    "passwd/username=${var.ssh_username} ", "-- <enter>"
  ]
  disk_size               = "${var.disk_size}"
  guest_os_type           = "${var.virtualbox_guest_os_type}"
  hard_drive_interface    = "sata"
  headless                = "${var.headless}"
  http_directory          = "http"
  iso_checksum            = "${var.iso_checksum_type}:${var.iso_checksum}"
  iso_urls                = [
    "${var.iso_path}/${var.iso_name}", 
    "${var.iso_url}"
  ]
  iso_target_path    = "/tmp/ubuntu-18.04.6-server-amd64.iso"
  output_directory        = "ca3"
  shutdown_command        = "echo 'A máquina não será desligada' && sleep 10"
  ssh_username            = "${var.ssh_username}"
  ssh_password            = "${var.ssh_password}"
  ssh_wait_timeout        = "10000s"
  guest_additions_mode    = "disable"
  keep_registered         = "true"
  skip_export             = "true"
  vboxmanage              = [
    ["modifyvm", "{{ .Name }}", "--audio", "none"], 
    ["modifyvm", "{{ .Name }}", "--usb", "off"], 
    ["modifyvm", "{{ .Name }}", "--vram", "12"], 
    ["modifyvm", "{{ .Name }}", "--vrde", "off"], 
    ["modifyvm", "{{ .Name }}", "--nictype1", "virtio"], 
    ["modifyvm", "{{ .Name }}", "--memory", "${var.memory}"], 
    ["modifyvm", "{{ .Name }}", "--cpus", "${var.cpus}"],
    #["modifyvm", "{{ .Name }}", "--nic1", "bridged"],  
    #["modifyvm", "{{ .Name }}", "--bridgeadapter1", "Intel(R) Wi-Fi 6 AX200 160MHz"]
    ["modifyvm", "{{ .Name }}", "--natpf1", "guestport8080,tcp,,8080,,8080"], 
    ["modifyvm", "{{ .Name }}", "--natpf1", "guestport59001,tcp,,59001,,59001"],
    ["modifyvm", "{{ .Name }}", "--natpf1", "guestport9092,tcp,,9092,,9092"]

  ]
  virtualbox_version_file = ".vbox_version"
  vm_name                 = "${var.vm_name_1}"
  format                  = "ova"
}

source "virtualbox-iso" "CA3-h2" {
  boot_command            = [
    "<esc><esc><enter><wait>", 
    "/install/vmlinuz noapic ", 
    "initrd=/install/initrd.gz ", 
    "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/${var.preseed} ", 
    "debian-installer=en_US auto locale=en_US kbd-chooser/method=us ", 
    "hostname=${var.hostname} ", 
    "grub-installer/bootdev=/dev/sda<wait> ", 
    "fb=false debconf/frontend=noninteractive ", 
    "keyboard-configuration/modelcode=SKIP keyboard-configuration/layout=USA ", 
    "keyboard-configuration/variant=USA console-setup/ask_detect=false ", 
    "passwd/user-fullname=${var.ssh_fullname} ", 
    "passwd/user-password=${var.ssh_password} ", 
    "passwd/user-password-again=${var.ssh_password} ", 
    "passwd/username=${var.ssh_username} ", "-- <enter>"
  ]
  disk_size               = "${var.disk_size}"
  guest_os_type           = "${var.virtualbox_guest_os_type}"
  hard_drive_interface    = "sata"
  headless                = "${var.headless}"
  http_directory          = "http"
  iso_checksum            = "${var.iso_checksum_type}:${var.iso_checksum}"
  iso_urls                = [
    "${var.iso_path}/${var.iso_name}", 
    "${var.iso_url}"
  ]
  iso_target_path    = "/tmp/ubuntu-18.04.6-server-amd64.iso"
  output_directory        = "ca3-h2"
  shutdown_command        = "echo 'A máquina não será desligada' && sleep 10"
  ssh_username            = "${var.ssh_username}"
  ssh_password            = "${var.ssh_password}"
  ssh_wait_timeout        = "10000s"
  guest_additions_mode    = "disable"
  keep_registered         = "true"
  skip_export             = "true"
  vboxmanage              = [
    ["modifyvm", "{{ .Name }}", "--audio", "none"], 
    ["modifyvm", "{{ .Name }}", "--usb", "off"], 
    ["modifyvm", "{{ .Name }}", "--vram", "12"], 
    ["modifyvm", "{{ .Name }}", "--vrde", "off"], 
    ["modifyvm", "{{ .Name }}", "--nictype1", "virtio"], 
    ["modifyvm", "{{ .Name }}", "--memory", "${var.memory}"], 
    ["modifyvm", "{{ .Name }}", "--cpus", "${var.cpus}"],
    #["modifyvm", "{{ .Name }}", "--nic1", "bridged"],  
    #["modifyvm", "{{ .Name }}", "--bridgeadapter1", "Intel(R) Wi-Fi 6 AX200 160MHz"]
    ["modifyvm", "{{ .Name }}", "--natpf1", "guestport8080,tcp,,8080,,8080"], 
    ["modifyvm", "{{ .Name }}", "--natpf1", "guestport59001,tcp,,59001,,59001"],
    ["modifyvm", "{{ .Name }}", "--natpf1", "guestport9092,tcp,,9092,,9092"]

  ]
  virtualbox_version_file = ".vbox_version"
  vm_name                 = "${var.vm_name_2}"
  format                  = "ova"
}


build {
  sources = [
    "source.virtualbox-iso.CA3",
    "source.virtualbox-iso.CA3-h2"
  ]

  # Primeira VM
  provisioner "file" {
    source      = "${var.home}/.ssh/id_ed25519.pub"
    destination = "/home/ubuntu/authorized_keys"
    only        = ["source.virtualbox-iso.CA3"]
  }

  provisioner "file" {
    source      = "${var.home}/.ssh/id_ed25519"  # Caminho para a chave no host
    destination = "/home/ubuntu/id_ed25519"  # Caminho de destino no VM
    only        = ["source.virtualbox-iso.CA3"]
  }

  provisioner "shell" {
    environment_vars  = [
      "DEBIAN_FRONTEND=noninteractive", 
      "UPDATE=${var.update}", 
      "SSH_USERNAME=${var.ssh_username}", 
      "SSH_PASSWORD=${var.ssh_password}", 
      "http_proxy=${var.http_proxy}", 
      "https_proxy=${var.https_proxy}", 
      "no_proxy=${var.no_proxy}",
      "VM_NAME=${var.vm_name_1}",
    ]
    execute_command   = "echo '${var.ssh_password}'|{{ .Vars }} sudo -E -S bash '{{ .Path }}'"
    expect_disconnect = true
    scripts           = [
      "script/update.sh", 
      "script/cleanup.sh",
      "script/provision.sh",
    ]
    only              = ["source.virtualbox-iso.CA3"]
  }

  # Segunda VM
  provisioner "file" {
    source      = "${var.home}/.ssh/id_ed25519.pub"
    destination = "/home/ubuntu/authorized_keys"
    only        = ["source.virtualbox-iso.CA3-h2"]
  }

  provisioner "file" {
    source      = "${var.home}/.ssh/id_ed25519"  # Caminho para a chave no host
    destination = "/home/ubuntu/id_ed25519"  # Caminho de destino no VM
    only        = ["source.virtualbox-iso.CA3-h2"]
  }

  provisioner "shell" {
    environment_vars  = [
      "DEBIAN_FRONTEND=noninteractive", 
      "UPDATE=${var.update}", 
      "SSH_USERNAME=${var.ssh_username}", 
      "SSH_PASSWORD=${var.ssh_password}", 
      "http_proxy=${var.http_proxy}", 
      "https_proxy=${var.https_proxy}", 
      "no_proxy=${var.no_proxy}",
      "VM_NAME=${var.vm_name_2}",
    ]
    execute_command   = "echo '${var.ssh_password}'|{{ .Vars }} sudo -E -S bash '{{ .Path }}'"
    expect_disconnect = true
    scripts           = [
      "script/update.sh", 
      "script/cleanup.sh",
      "script/provision.sh",
    ]
    only              = ["source.virtualbox-iso.CA3-h2"]
  }
}


