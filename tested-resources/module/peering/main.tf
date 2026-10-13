resource "azurerm_virtual_network_peering" "this" {
  for_each                  = var.peer
  name                      = each.key
  resource_group_name       = each.value.resource_group_name
  virtual_network_name      = each.value.local_vnet_name
  remote_virtual_network_id = each.value.remote_vnet_id

  # Standard enterprise Hub-and-Spoke peering settings
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}