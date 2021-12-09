// declare variables
variable DO_token {
    type = string
    sensitive = true
    default = "4b4991139933a810c5fcb3574ff3b64c100d68f52aef7f7d7e7369f654e91bbc"
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
    type = string
    default = "s-1vcpu-1gb"
}

variable public_key {
   type = string
   default = "../../mykey.pub"
}

// builders
source digitalocean code-server {
    api_token = var.DO_token
    image = var.DO_image
    size = var.DO_size
    region = var.DO_region
    ssh_username = "root"
    snapshot_name = "code-server"
}

build {
    sources = [ "source.digitalocean.code-server" ]
    provisioner ansible {
        playbook_file = "./playbook.yaml"
        extra_arguments = [
            "-e", "public_key_file=${var.public_key}"
        ]
    }
}