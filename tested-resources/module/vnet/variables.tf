variable "vnets" {
  type = map(object({
    resource_group_name = string
    name                = string
    location            = string
    address_space       = list(string)
  }))
}