
variable "do_token" {
  type      = string
  sensitive = true
  default   = "aecb46d4f5581bbcfa9c0a0570bbfa6aab558bb4e07920293286d04f72986474"
}

variable "do_image" {
  type    = string
  default = "ubuntu-20-04-x64"
}

variable "do_size" {
  type    = string
  default = "s-1vcpu-1gb"
}

variable "do_region" {
  type    = string
  default = "sgp1"
}


variable "ipv4dockerhost" {
  type = string
  default = "http://159.223.79.113"
}

variable "containers" {
  type = list(object({
    imageName     = string
    containerName = string
    containerPort = number
    externalPort  = number
    envVariables  = list(string)
    keepImage     = bool
  }))

  default = [
    {
      imageName     = "stackupiss/dov-bear:v2"
      containerName = "dov-bear0"
      containerPort = 3000
      externalPort  = 8080
      keepImage     = true
      envVariables  = ["INSTANCE_NAME=dov-bear0", "INSTANCE_HASH=dovbear0"]
    },
    {
      imageName     = "stackupiss/dov-bear:v2"
      containerName = "dov-bear1"
      containerPort = 3000
      externalPort  = 8081
      keepImage     = true
      envVariables  = ["INSTANCE_NAME=dov-bear1", "INSTANCE_HASH=dovbear1"]
    },
    {
      imageName     = "stackupiss/dov-bear:v2"
      containerName = "dov-bear2"
      containerPort = 3000
      externalPort  = 8082
      keepImage     = true
      envVariables  = ["INSTANCE_NAME=dov-bear2", "INSTANCE_HASH=dovbear2"]
    },
  ]
}

