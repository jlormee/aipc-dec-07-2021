# // docker pull stackupiss/dov-bear:v2
# resource "docker_image" "dov-bear" {
#   name         = "stackupiss/dov-bear:${var.tagversion}"
#   keep_locally = var.keep_image
# }

# resource "docker_image" "dov-fortune" {
#   name         = "stackupiss/fortune:v2"
#   keep_locally = true
# }

# resource "docker_container" "dov-app" {
#   // --name app0
#   name = var.name
#   // docker run -d -p 8080:3000 ... stackupiss/dov-bear:v2
#   image = docker_image.dov-bear.latest
#   ports {
#     internal = 3000
#     external = 8080
#   }
#   env = ["INSTANCE_NAME=dov-app", "INSTANCE_HASH=abc123"]
# }

# resource "docker_container" "dov-fortune" {
#   // --name app0
#   name = "app01"
#   // docker run -d -p 8080:3000 ... stackupiss/dov-bear:v2
#   image = docker_image.dov-fortune.latest
#   ports {
#     internal = 3000
#     external = 8081
#   }
#   env = ["INSTANCE_NAME=dov-app", "INSTANCE_HASH=abc123"]
# }

# Using variables to shorten the codes above
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

output "externalPorts" {
  value     = flatten(docker_container.container-app[*].ports[*].external)
  sensitive = false
}
# output "port0" {
#   value = docker_container.container-app[0].ports[0].external
# }

# output "port1" {
#   value = docker_container.container-app[1].ports[0].external
# }
