# 1. Generate the Public IP for the Firewall
resource "azurerm_public_ip" "this" {
  for_each            = var.fire
  name                = "pip-${each.value.name}"
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# 2. Generate the Firewall and attach the Public IP
resource "azurerm_firewall" "this" {
  for_each            = var.fire
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku_name            = each.value.sku_name
  sku_tier            = each.value.sku_tier

  ip_configuration {
    name                 = "fw-ipconfig"
    subnet_id            = each.value.subnet_id
    public_ip_address_id = azurerm_public_ip.this[each.key].id
  }
}