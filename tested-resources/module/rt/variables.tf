variable "route_tables" {
  description = "Map of route tables with subnet associations and custom routes"
  type = map(object({
    name                          = string
    resource_group_name           = string
    location                      = string
    disable_bgp_route_propagation = optional(bool, true)
    subnet_id                     = string
    routes = map(object({
      name                   = string
      address_prefix         = string
      next_hop_type          = string
      next_hop_in_ip_address = optional(string, null)
    }))
  }))
}