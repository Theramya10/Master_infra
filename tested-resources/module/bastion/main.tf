resource "azurerm_public_ip" "this" {
  for_each            = var.bastions
  name                = "pip-${each.value.name}"
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "this" {
  for_each            = var.bastions
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku                 = each.value.sku

  ip_configuration {
    name                 = "bastion-ipconfig"
    subnet_id            = each.value.subnet_id
    public_ip_address_id = azurerm_public_ip.this[each.key].id
  }
}