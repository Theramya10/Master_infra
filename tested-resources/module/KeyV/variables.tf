variable "kv" {
  description = "Map of Key Vaults to provision"
  type = map(object({
    name                       = string
    location                   = string
    resource_group_name        = string
    sku_name                   = string
    purge_protection_enabled   = bool
    soft_delete_retention_days = number
    rbac_authorization_enabled = bool
  }))
}