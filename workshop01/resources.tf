# Docker containers
resource "docker_image" "container-image" {
  count        = length(var.containers)
  name         = var.containers[count.index].imageName
  keep_locally = var.containers[count.index].keepImage
}
resource "docker_container" "container-app" {
  count = length(var.containers)
  name  = var.containers[count.index].containerName
  image = docker_image.container-image[count.index].latest
  ports {
    internal = var.containers[count.index].containerPort
    external = var.containers[count.index].externalPort
  }
  env = var.containers[count.index].envVariables
}

output "ContainerExposePorts" {
  value     = join(" ", [var.ipv4dockerhost, join(", ", flatten(docker_container.container-app[*].ports[*].external))])
  sensitive = false
}

resource "local_file" "nginxconf" {
  filename = "nginx.conf"
  content = templatefile("template-nginx.conf.tpl", {
    host = var.ipv4dockerhost
    # port0 = docker_container.container-app[0].ports[0].external
    # port1 = docker_container.container-app[1].ports[0].external
    # port2 = docker_container.container-app[2].ports[0].external
    ports = flatten(docker_container.container-app[*].ports[*].external)
  })
  file_permission = "0644"
}


#Create digital ocean droplet
data "digitalocean_ssh_key" "my-key" {
  name = "myworkshop1key"
  # Set up in digital ocean this key
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

  provisioner "remote-exec" {
    inline = [
      "apt update -y",
      "apt upgrade -y",
      "apt install nginx -y",
      "systemctl enable nginx",
      "systemctl start nginx"
    ]
  }

  provisioner "file" {
    source      = local_file.nginxconf.filename // "nginx.conf"
    destination = "/etc/nginx/nginx.conf"
  }

  provisioner "remote-exec" {
    inline = [
      "/usr/sbin/nginx -s reload"
    ]
  }

}

# Local template file try out
resource "local_file" "droplet_info" {
  filename = "root@${digitalocean_droplet.my-droplet-from-terraform.ipv4_address}"
  content = templatefile("info.txt.tpl", {
    ipv4        = digitalocean_droplet.my-droplet-from-terraform.ipv4_address
    fingerprint = data.digitalocean_ssh_key.my-key.fingerprint
  })
  file_permission = "0644"
}

output "ReverseProxyIpv4" {
  value = digitalocean_droplet.my-droplet-from-terraform.ipv4_address
}

output "my-key-fingerprint" {
  value = data.digitalocean_ssh_key.my-key.fingerprint
}
