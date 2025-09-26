variable "location" {
  type    = string
  default = "East US"
}

variable "admin_username" {
  type    = string
  default = "azureuser"
}

variable "ssh_public_key" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}

variable "pg_admin" {
  type    = string
  default = "pgadmin"
}

variable "pg_password" {
  type      = string
  sensitive = true
}
