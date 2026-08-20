variable "name" {
  description = "Name of the Azure Front Door profile."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group the Front Door profile is created in."
  type        = string
}

variable "sku_name" {
  description = "SKU of the Front Door profile."
  type        = string
  default     = "Standard_AzureFrontDoor"

  validation {
    condition     = contains(["Standard_AzureFrontDoor", "Premium_AzureFrontDoor"], var.sku_name)
    error_message = "sku_name must be one of: Standard_AzureFrontDoor, Premium_AzureFrontDoor."
  }
}

variable "endpoint_name" {
  description = "Name of the Front Door endpoint. Forms part of the generated *.azurefd.net hostname."
  type        = string
}

variable "origin_groups" {
  description = "Map of origin groups, keyed by a unique origin group name."
  type = map(object({
    session_affinity_enabled                                  = optional(bool, false)
    restore_traffic_time_to_healed_or_new_endpoint_in_minutes = optional(number, 10)
    health_probe = optional(object({
      protocol            = optional(string, "Https")
      interval_in_seconds = optional(number, 100)
      request_type        = optional(string, "GET")
      path                = optional(string, "/")
    }))
    load_balancing = optional(object({
      additional_latency_in_milliseconds = optional(number, 50)
      sample_size                        = optional(number, 4)
      successful_samples_required        = optional(number, 3)
    }), {})
  }))
}

variable "origins" {
  description = "Map of origins, keyed by a unique origin name. Each origin belongs to one origin group."
  type = map(object({
    origin_group_key               = string
    host_name                      = string
    origin_host_header             = optional(string)
    certificate_name_check_enabled = optional(bool, true)
    priority                       = optional(number, 1)
    weight                         = optional(number, 500)
    http_port                      = optional(number, 80)
    https_port                     = optional(number, 443)
  }))
}

variable "routes" {
  description = "Map of routes, keyed by a unique route name. Each route forwards matched patterns to an origin group."
  type = map(object({
    origin_group_key       = string
    patterns_to_match      = list(string)
    supported_protocols    = optional(list(string), ["Http", "Https"])
    forwarding_protocol    = optional(string, "HttpsOnly")
    https_redirect_enabled = optional(bool, true)
    link_to_default_domain = optional(bool, true)
    custom_domain_keys     = optional(list(string), [])
  }))
}

variable "custom_domains" {
  description = "Map of custom domains associated with routes, keyed by a unique domain name."
  type = map(object({
    host_name        = string
    dns_zone_id      = optional(string)
    certificate_type = optional(string, "ManagedCertificate")
  }))
  default = {}
}

variable "security_policy" {
  description = "WAF security policy wiring applied to the custom domains and default endpoint. Set to null to skip WAF association."
  type = object({
    waf_policy_id      = string
    custom_domain_keys = optional(list(string), [])
    patterns_to_match  = optional(list(string), ["/*"])
    associate_endpoint = optional(bool, true)
  })
  default = null
}

variable "tags" {
  description = "Tags applied to every resource created by this module."
  type        = map(string)
  default     = {}
}
