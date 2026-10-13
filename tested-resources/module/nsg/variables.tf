variable "nsg" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
  }))
}
variable "nsga" {
  type = map(object({
    subnet_id = string
  }))

}