
# Example on how to use var.tagversion
# variable "tagversion" {
#   type    = string
#   default = "v2"
# }
# variable "keep_image" {
#   type    = bool
#   default = true
# }

# variable "name" {
#   type = string
# }

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
      containerName = "dov-bear"
      containerPort = 3000
      externalPort  = 8080
      keepImage     = true
      envVariables  = ["INSTANCE_NAME=dov", "INSTANCE_HASH=abc1234"]
    },
    {
      imageName     = "stackupiss/fortune:v2"
      containerName = "fortune"
      containerPort = 3000
      externalPort  = 8081
      keepImage     = true
      envVariables  = []
    }
  ]
}
