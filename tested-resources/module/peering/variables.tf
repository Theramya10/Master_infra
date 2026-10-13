variable "peer" {
  description = "Map of VNet peerings to establish"
  type = map(object({
    local_vnet_name     = string
    remote_vnet_id      = string
    resource_group_name = string
  }))
}