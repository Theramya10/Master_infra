variable "location" {
  description = "Target Azure region for deployment"
  type        = string
}

variable "environment" {
  description = "Deployment environment name (e.g., dev, prod)"
  type        = string
}

# --- Network CIDR Blocks ---
variable "vnet_cidrs" {
  description = "Address spaces for Hub and Spoke VNets"
  type        = map(list(string))
}

variable "subnet_prefixes" {
  description = "Address prefixes for all Hub and Spoke subnets"
  type        = map(string)
}

# --- Azure Bastion & Firewall Settings ---
variable "bastion_sku" {
  description = "SKU for Azure Bastion"
  type        = string
  default     = "Basic"
}

variable "firewall_sku_name" {
  description = "SKU name for Azure Firewall"
  type        = string
  default     = "AZFW_VNet"
}

variable "firewall_sku_tier" {
  description = "SKU tier for Azure Firewall"
  type        = string
  default     = "Standard"
}

variable "firewall_private_ip" {
  description = "Reserved private IP for Azure Firewall used as Next Hop"
  type        = string
  default     = "10.0.1.4"
}

# --- Compute / VM Settings ---
variable "vm_admin_username" {
  description = "Administrator username for Linux VMs"
  type        = string
  default     = "axionadmin"
}

variable "vm_adminpa" {
  description = "Password for the Bastion-accessed VMs"
  type        = string
  sensitive   = true
}

variable "vm_size" {
  description = "Default VM compute size"
  type        = string
  default     = "Standard_B2s"
}

# --- Application Gateway Settings (When ready to enable) ---
variable "appgw_waf_mode" {
  description = "WAF operational mode (Prevention or Detection)"
  type        = string
  default     = "Prevention"
}

variable "kv_config" {
  description = "Configuration map for Key Vaults"
  type = map(object({
    name_suffix                = string
    sku_name                   = string
    purge_protection_enabled   = bool
    soft_delete_retention_days = number
    rbac_authorization_enabled = bool
  }))
}