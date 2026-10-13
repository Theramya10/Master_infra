output "subnet_ids" {
  description = "Map of created Subnet IDs"
  value       = { for k, v in azurerm_subnet.sub : k => v.id }
}