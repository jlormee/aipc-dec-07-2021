
# resource "digitalocean_droplet" "my-droplet-from-terraform" {
#   image  = var.do_image
#   region = var.do_region
#   size   = var.do_size
#   name   = "mydropletfromterraform"
# }

# output "ipv4" {
#   value = digitalocean_droplet.my-droplet-from-terraform.ipv4_address
# }

data "digitalocean_ssh_key" "my-key" {
  name = "myworkshop1key"
}

resource "digitalocean_droplet" "example" {
  image    = var.do_image
  region   = var.do_region
  size     = var.do_size
  name     = "mydropletfromterraform"
  ssh_keys = [data.digitalocean_ssh_key.my-key.fingerprint]
  connection {
    type        = "ssh"
    user        = "root"
    private_key = file("./mykey")
    host        = self.ipv4_address
  }

  provisioner "remote-exec" {
    inline = [
      "apt update -y",
      "apt upgrade -y",
      "apt install nginx -y",
      "systemctl enable nginx",
      "systemctl start nginx"
    ]
  }
}

# Local template file try out
resource "local_file" "droplet_info" {
  filename = "info.txt"
  content = templatefile("info.txt.tpl", {
    ipv4        = digitalocean_droplet.example.ipv4_address
    fingerprint = data.digitalocean_ssh_key.my-key.fingerprint
  })
  file_permission = "0644"
}

output "ipv4" {
  value = digitalocean_droplet.example.ipv4_address
}

output "my-key-fingerprint" {
  value = data.digitalocean_ssh_key.my-key.fingerprint
}

