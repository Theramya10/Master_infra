# 1. Resource Group
module "rg" {
  source   = "../module/rg"
  name     = "rg-axion-${var.environment}"
  location = var.location
}

# 2. Virtual Networks
module "vnet" {
  source = "../module/vnet"

  vnets = {
    "hub" = {
      name                = "vnet-hub"
      address_space       = var.vnet_cidrs["hub"]
      resource_group_name = module.rg.name
      location            = module.rg.location
    },
    "fe" = {
      name                = "vnet-spoke-fe"
      address_space       = var.vnet_cidrs["fe"]
      resource_group_name = module.rg.name
      location            = module.rg.location
    },
    "be" = {
      name                = "vnet-spoke-be"
      address_space       = var.vnet_cidrs["be"]
      resource_group_name = module.rg.name
      location            = module.rg.location
    },
    "db" = {
      name                = "vnet-spoke-db"
      address_space       = var.vnet_cidrs["db"]
      resource_group_name = module.rg.name
      location            = module.rg.location
    }
  }

  depends_on = [module.rg]
}

# 3. Subnets
module "subnet" {
  source = "../module/subnet"

  sub = {
    "AzureFirewallSubnet" = {
      name                 = "AzureFirewallSubnet"
      resource_group_name  = module.rg.name
      virtual_network_name = "vnet-hub"
      address_prefixes     = ["10.0.1.0/26"]
    },
    "AzureBastionSubnet" = {
      name                 = "AzureBastionSubnet"
      resource_group_name  = module.rg.name
      virtual_network_name = "vnet-hub"
      address_prefixes     = ["10.0.2.0/26"]
    },
    "snet-appgw" = {
      name                 = "snet-appgw"
      resource_group_name  = module.rg.name
      virtual_network_name = "vnet-hub"
      address_prefixes     = ["10.0.3.0/24"]
    },
    "snet-fe" = {
      name                 = "snet-fe"
      resource_group_name  = module.rg.name
      virtual_network_name = "vnet-spoke-fe"
      address_prefixes     = ["10.1.1.0/24"]
    },
    "snet-be" = {
      name                 = "snet-be"
      resource_group_name  = module.rg.name
      virtual_network_name = "vnet-spoke-be"
      address_prefixes     = ["10.2.1.0/24"]
    },
    "snet-db" = {
      name                 = "snet-db"
      resource_group_name  = module.rg.name
      virtual_network_name = "vnet-spoke-db"
      address_prefixes     = ["10.3.1.0/24"]
    }
  }

  depends_on = [module.vnet]
}

# 4. VNet Peering
module "peering" {
  source = "../module/peering"

  peer = {
    "hub-to-fe" = {
      local_vnet_name     = module.vnet.vnet_names["hub"]
      remote_vnet_id      = module.vnet.vnet_ids["fe"]
      resource_group_name = module.rg.name
    },
    "hub-to-be" = {
      local_vnet_name     = module.vnet.vnet_names["hub"]
      remote_vnet_id      = module.vnet.vnet_ids["be"]
      resource_group_name = module.rg.name
    },
    "hub-to-db" = {
      local_vnet_name     = module.vnet.vnet_names["hub"]
      remote_vnet_id      = module.vnet.vnet_ids["db"]
      resource_group_name = module.rg.name
    },
    "fe-to-hub" = {
      local_vnet_name     = module.vnet.vnet_names["fe"]
      remote_vnet_id      = module.vnet.vnet_ids["hub"]
      resource_group_name = module.rg.name
    },
    "be-to-hub" = {
      local_vnet_name     = module.vnet.vnet_names["be"]
      remote_vnet_id      = module.vnet.vnet_ids["hub"]
      resource_group_name = module.rg.name
    },
    "db-to-hub" = {
      local_vnet_name     = module.vnet.vnet_names["db"]
      remote_vnet_id      = module.vnet.vnet_ids["hub"]
      resource_group_name = module.rg.name
    }
  }

  depends_on = [module.vnet]
}

# 5. Core Infrastructure
module "FW" {
  source = "../module/FW"

  fire = {
    "hub_fw" = {
      name                = "fw-hub-${var.environment}"
      resource_group_name = module.rg.name
      location            = var.location
      subnet_id           = module.subnet.subnet_ids["AzureFirewallSubnet"]
      sku_name            = var.firewall_sku_name
      sku_tier            = var.firewall_sku_tier
    }
  }

  depends_on = [module.subnet]
}

module "bastion" {
  source = "../module/bastion"

  bastions = {
    "hub_bastion" = {
      name                = "bastion-hub-${var.environment}"
      resource_group_name = module.rg.name
      location            = var.location
      subnet_id           = module.subnet.subnet_ids["AzureBastionSubnet"]
      sku                 = var.bastion_sku
    }
  }
  depends_on = [module.subnet]
}

module "appget" {
  source = "../module/appget"

  app_gateways = {
    "hub_appgw" = {
      name                 = "appgw-hub-${var.environment}"
      resource_group_name  = module.rg.name
      location             = var.location
      subnet_id            = module.subnet.subnet_ids["snet-appgw"]
      waf_mode             = var.appgw_waf_mode
      backend_ip_addresses = ["10.1.1.4"]
    }
  }
  depends_on = [module.subnet]
}

# 6. Route Tables
module "route_tables" {
  source = "../module/rt"

  route_tables = {
    "fe_rt" = {
      name                = "rt-spoke-fe-prod"
      resource_group_name = module.rg.name
      location            = module.rg.location
      subnet_id           = module.subnet.subnet_ids["snet-fe"]
      routes = {
        "to_backend" = { name = "route-fe-to-be-via-fw", address_prefix = "10.2.0.0/16", next_hop_type = "VirtualAppliance", next_hop_in_ip_address = "10.0.1.4" }
      }
    }
    "be_rt" = {
      name                = "rt-spoke-be-prod"
      resource_group_name = module.rg.name
      location            = module.rg.location
      subnet_id           = module.subnet.subnet_ids["snet-be"]
      routes = {
        "to_frontend" = { name = "route-be-to-fe-via-fw", address_prefix = "10.1.0.0/16", next_hop_type = "VirtualAppliance", next_hop_in_ip_address = "10.0.1.4" },
        "to_database" = { name = "route-be-to-db-via-fw", address_prefix = "10.3.0.0/16", next_hop_type = "VirtualAppliance", next_hop_in_ip_address = "10.0.1.4" }
      }
    }
    "db_rt" = {
      name                = "rt-spoke-db-prod"
      resource_group_name = module.rg.name
      location            = module.rg.location
      subnet_id           = module.subnet.subnet_ids["snet-db"]
      routes = {
        "to_backend" = { name = "route-db-to-be-via-fw", address_prefix = "10.2.0.0/16", next_hop_type = "VirtualAppliance", next_hop_in_ip_address = "10.0.1.4" }
      }
    }
  }

  depends_on = [module.FW, module.peering]
}

# 7. Virtual Machines
module "virtual_machines" {
  source = "../module/vm"

  virtual_machines = {
    "fe_vm" = {
      name                            = "vm-spoke-fe-prod"
      resource_group_name             = module.rg.name
      location                        = module.rg.location
      subnet_id                       = module.subnet.subnet_ids["snet-fe"]
      size                            = "Standard_D2s_v3"
      admin_username                  = "theramya10"
      admin_password                  = var.vm_adminpa
      disable_password_authentication = false
    },
    "be_vm" = {
      name                            = "vm-spoke-be-prod"
      resource_group_name             = module.rg.name
      location                        = module.rg.location
      subnet_id                       = module.subnet.subnet_ids["snet-be"]
      size                            = "Standard_D2s_v3"
      admin_username                  = "axionadmin"
      admin_password                  = var.vm_adminpa
      disable_password_authentication = false
    },
    "db_vm" = {
      name                            = "vm-spoke-db-prod"
      resource_group_name             = module.rg.name
      location                        = module.rg.location
      subnet_id                       = module.subnet.subnet_ids["snet-db"]
      size                            = "Standard_D2s_v3"
      admin_username                  = "axionadmin"
      admin_password                  = var.vm_adminpa
      disable_password_authentication = false
    }
  }

  depends_on = [module.route_tables, module.peering]
}

module "keyvault" {
  source = "../module/KeyV"

  kv = {
    "primary_kv" = {
      name                       = "kv-axion-${var.environment}-01"
      location                   = var.location
      resource_group_name        = module.rg.name
      sku_name                   = "standard"
      purge_protection_enabled   = false
      soft_delete_retention_days = 7
      rbac_authorization_enabled = true
    }
  }

  depends_on = [module.rg]
}