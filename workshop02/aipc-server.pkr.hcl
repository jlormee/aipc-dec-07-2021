variable DO_token {
    type = string
    sensitive = true
    default = ""
}

variable DO_region {
    type = string
    default = "sgp1"
}

variable DO_image {
    type = string
    default = "ubuntu-20-04-x64"
}

variable DO_size {
  type    = string
  default = "s-1vcpu-1gb"
}

variable public_key {
    type = string
    default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC1wzaTbrVm9VbVA7osfzcd9X916Kd3bFawDWvNRnHzn117Ur9AeIYUmBX9EiwF3PsC3i7Oe8qxAe3gzvZoVwclXEqSOMM3N+5lzNaINOZh7/QHcuyBxAKNkMhaygRwzS/c1UxByr6G/DY7JqJIT3Q+voTvwv4LZdh3KgVAsKjB0G2PJ8P9t/DcUw+h4IBUn3kbIFllMhV0swtRCNcyyNSmS1u5AZAWUJvNq+n3htQ37wE8hX5c/OcSVGtJX9+U8JF24EoZz2eG0DLjBVSGRxPsFZBZZp/qI3MHXY9o9X3zaA3gfluVkaAv1Td0XdtwT2lSL4QRAGw3rgSrkrnD4ulEmikoVZqQJB6UTTTQR6twyNwEzoi6Pb5nZrep0Ee+R/QPC8Av23iD2HTaO4W5G+7yCA+oV9vW/FgK9TMdlgwQ/NyhepRQS/wF7QpS0JqUzBuZ9Cc9ka6goUXkJbfnh0FPUF8GgcGBKVbkJ4b8FQMSIbeL288qvA+6kuqcGqLJC2E= fred@ubuntu-s-2vcpu-2gb-sgp1-01"
}

//builders 
source digitalocean apic-server {
    api_token = var.DO_token
    image = var.DO_image
    size = var.DO_size
    region = var.DO_region
    ssh_username = "root"
    snapshot_name = "apic-server"
}

build {
    sources = ["source.digitalocean.apic-server"]
    provisioner ansible {
        playbook_file = "./playbook.yaml"
        extra_arguments {
            "-e", "public_key_file=${var.public_key}"
        }
    }
}