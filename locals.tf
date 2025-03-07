locals {
  # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account_network_rules#ip_rules
  # > Small address ranges using "/31" or "/32" prefix sizes are not supported. These ranges should be configured using individual IP address rules without prefix specified.
  storage_ip_rules = toset(flatten([for cidr in var.allowed_cidrs : (length(regexall("/3.", cidr)) > 0 ? [cidrhost(cidr, 0), cidrhost(cidr, -1)] : [cidr])]))

  storage_blob_data_protection = defaults(var.storage_blob_data_protection, {
    change_feed_enabled                       = false
    versioning_enabled                        = false
    container_point_in_time_restore           = false
    delete_retention_policy_in_days           = 0
    container_delete_retention_policy_in_days = 0
  })
}
