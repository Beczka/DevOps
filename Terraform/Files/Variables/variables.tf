# https://www.terraform.io/docs/configuration/variables.html

# Strings
variable "key" {
  type    = "string"
  default = "value"
}

# Maps
variable "images" {
  type = "map"

  default = {
    "us-east-1" = "image-1234"
    "us-west-2" = "image-4567"
  }
}

# Lists
variable "users" {
  type    = "list"
  default = ["admin", "ubuntu"]
}

# Lists of maps
variable "users" {
  type = "list"

  default = [
    {
      "us-east-1" = "image-1234"
      "us-west-2" = "image-4567"
    },
    {
      "us-east-1" = "image-1234"
      "us-west-2" = "image-4567"
    },
  ]
}

# Booleans => string
variable "active" {
  default = false
}
