#Create digital ocean droplet
data "digitalocean_ssh_key" "my-key" {
  name = "myworkshop1key"
}

resource "digitalocean_droplet" "my-droplet-from-terraform" {
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
}

# Local template file try out
resource "local_file" "droplet_inventory_yaml" {
  filename = "inventory.yaml"
  content = templatefile("inventory.yaml.tpl", {
    host          = digitalocean_droplet.my-droplet-from-terraform.ipv4_address
    mysqlpassword = ""
  })
  file_permission = "0644"
}

output "ReverseProxyIpv4" {
  value = digitalocean_droplet.my-droplet-from-terraform.ipv4_address
}
