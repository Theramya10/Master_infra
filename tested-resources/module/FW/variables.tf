variable "fire" {
  description = "Map of Azure Firewalls to deploy"
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    subnet_id           = string
    sku_name            = optional(string, "AZFW_VNet")
    sku_tier            = optional(string, "Standard")
  }))
}