output "vnet_names" {
  description = "Map of created VNet names"
  value       = { for k, v in azurerm_virtual_network.vnet : k => v.name }
}

output "vnet_ids" {
  description = "Map of created VNet IDs"
  value       = { for k, v in azurerm_virtual_network.vnet : k => v.id }
}

