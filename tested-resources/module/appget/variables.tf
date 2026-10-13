variable "app_gateways" {
  description = "Map of Application Gateways to deploy"
  type = map(object({
    name                 = string
    resource_group_name  = string
    location             = string
    subnet_id            = string
    backend_ip_addresses = list(string)
    waf_mode             = optional(string, "Prevention")
  }))
}