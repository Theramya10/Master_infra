resource "azurerm_public_ip" "this" {
  for_each            = var.app_gateways
  name                = "pip-${each.value.name}"
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_web_application_firewall_policy" "this" {
  for_each            = var.app_gateways
  name                = "wafpol-${each.value.name}"
  resource_group_name = each.value.resource_group_name
  location            = each.value.location

  policy_settings {
    enabled                     = true
    mode                        = each.value.waf_mode
    request_body_check          = true
    max_request_body_size_in_kb = 128
  }

  managed_rules {
    managed_rule_set {
      type    = "OWASP"
      version = "3.2"
    }
  }
}

resource "azurerm_application_gateway" "this" {
  for_each            = var.app_gateways
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 2
  }

  firewall_policy_id = azurerm_web_application_firewall_policy.this[each.key].id

  gateway_ip_configuration {
    name      = "appgw-ip-config"
    subnet_id = each.value.subnet_id
  }

  frontend_port {
    name = "port_80"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "fe_ip_config"
    public_ip_address_id = azurerm_public_ip.this[each.key].id
  }

  backend_address_pool {
    name         = "backend_pool"
    ip_addresses = each.value.backend_ip_addresses
  }

  backend_http_settings {
    name                  = "http_settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = "listener_80"
    frontend_ip_configuration_name = "fe_ip_config"
    frontend_port_name             = "port_80"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "routing_rule"
    rule_type                  = "Basic"
    http_listener_name         = "listener_80"
    backend_address_pool_name  = "backend_pool"
    backend_http_settings_name = "http_settings"
    priority                   = 100
  }
}