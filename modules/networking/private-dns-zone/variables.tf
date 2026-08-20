variable "name" {
  description = "Name of the private DNS zone, e.g. internal.contoso.com."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group the private DNS zone is created in."
  type        = string
}

variable "records" {
  description = "Map of DNS records to create in the zone, keyed by record name."
  type = map(object({
    type   = string
    ttl    = number
    values = optional(list(string), [])
    mx_records = optional(list(object({
      preference = number
      exchange   = string
    })), [])
    srv_records = optional(list(object({
      priority = number
      weight   = number
      port     = number
      target   = string
    })), [])
    txt_records = optional(list(object({
      value = string
    })), [])
  }))
  default = {}

  validation {
    condition     = alltrue([for r in values(var.records) : contains(["A", "AAAA", "CNAME", "MX", "PTR", "SRV", "TXT"], r.type)])
    error_message = "record type must be one of A, AAAA, CNAME, MX, PTR, SRV, TXT."
  }
}

variable "virtual_network_links" {
  description = "Map of virtual network links to create for the zone, keyed by a logical name."
  type = map(object({
    virtual_network_id   = string
    registration_enabled = optional(bool, false)
  }))
  default = {}
}

variable "tags" {
  description = "Tags applied to every resource created by this module."
  type        = map(string)
  default     = {}
}
