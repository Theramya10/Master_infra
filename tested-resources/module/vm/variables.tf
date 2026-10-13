variable "virtual_machines" {
  description = "A map of Linux virtual machines to deploy in the spokes using password authentication via Bastion"
  type = map(object({
    name                            = string
    resource_group_name             = string
    location                        = string
    subnet_id                       = string
    size                            = string
    admin_username                  = string
    admin_password                  = string
    disable_password_authentication = optional(bool, false)
  }))
}