variable "bastions" {
  description = "Map of Azure Bastion hosts to deploy"
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    subnet_id           = string
    sku                 = optional(string, "Basic")
  }))
}