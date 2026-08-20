variable "name" {
  description = "Prefix applied to every private endpoint created by this module."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group the private endpoints are created in."
  type        = string
}

variable "location" {
  description = "Azure region the private endpoints are deployed to."
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet the private endpoints are attached to."
  type        = string
}

variable "endpoints" {
  description = "Map of private endpoints to create, keyed by a logical name."
  type = map(object({
    private_connection_resource_id = string
    subresource_names              = optional(list(string), [])
    is_manual_connection           = optional(bool, false)
    request_message                = optional(string, null)
    private_dns_zone_ids           = optional(list(string), [])
  }))
  default = {}
}

variable "tags" {
  description = "Tags applied to every resource created by this module."
  type        = map(string)
  default     = {}
}
