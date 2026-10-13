data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  for_each                      = var.kv
  name                          = each.value.name
  location                      = each.value.location
  resource_group_name           = each.value.resource_group_name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = each.value.sku_name
  purge_protection_enabled      = each.value.purge_protection_enabled
  soft_delete_retention_days    = each.value.soft_delete_retention_days
  rbac_authorization_enabled    = each.value.rbac_authorization_enabled
  public_network_access_enabled = true

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }
}

resource "azurerm_role_assignment" "roassinment" {
  for_each             = var.kv
  scope                = azurerm_key_vault.kv[each.key].id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}