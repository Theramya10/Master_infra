resource "azurerm_route_table" "this" {
  for_each                      = var.route_tables
  name                          = each.value.name
  location                      = each.value.location
  resource_group_name           = each.value.resource_group_name
  bgp_route_propagation_enabled = each.value.disable_bgp_route_propagation ? false : true

  dynamic "route" {
    for_each = each.value.routes
    content {
      name                   = route.value.name
      address_prefix         = route.value.address_prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = route.value.next_hop_type == "VirtualAppliance" ? route.value.next_hop_in_ip_address : null
    }
  }
}

resource "azurerm_subnet_route_table_association" "this" {
  for_each       = var.route_tables
  subnet_id      = each.value.subnet_id
  route_table_id = azurerm_route_table.this[each.key].id
}