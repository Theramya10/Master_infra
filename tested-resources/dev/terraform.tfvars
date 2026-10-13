location    = "centralindia"
environment = "prod"

# Virtual Network Address Spaces
vnet_cidrs = {
  "hub" = ["10.0.0.0/16"]
  "fe"  = ["10.1.0.0/16"]
  "be"  = ["10.2.0.0/16"]
  "db"  = ["10.3.0.0/16"]
}

# Subnet Address Prefixes
subnet_prefixes = {
  "AzureFirewallSubnet" = "10.0.1.0/26"
  "AzureBastionSubnet"  = "10.0.2.0/26"
  "snet-appgw"          = "10.0.3.0/24"
  "snet-fe"             = "10.1.1.0/24"
  "snet-be"             = "10.2.1.0/24"
  "snet-db"             = "10.3.1.0/24"
}

# Hub Services Configuration
bastion_sku         = "Basic"
firewall_sku_name   = "AZFW_VNet"
firewall_sku_tier   = "Standard"
firewall_private_ip = "10.0.1.4"

# Compute Settings
vm_admin_username = "axionadmin"
vm_adminpa        = "SuperSecretPassword123!" # In real CI/CD pipelines, inject this dynamically
vm_size           = "Standard_B2s"

# App Gateway Setting
appgw_waf_mode = "Prevention"

kv_config = {
  "primary_kv" = {
    name_suffix                = "01" # Will become kv-axion-dev-01
    sku_name                   = "standard"
    purge_protection_enabled   = false # Keep false for Dev, true for Prod
    soft_delete_retention_days = 7
    rbac_authorization_enabled = true
  }
}