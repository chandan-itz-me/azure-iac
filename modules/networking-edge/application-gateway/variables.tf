variable "name" {
  description = "Name of the application gateway."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group the application gateway is created in."
  type        = string
}

variable "location" {
  description = "Azure region the application gateway is deployed to."
  type        = string
}

variable "sku_name" {
  description = "SKU name of the application gateway."
  type        = string
  default     = "WAF_v2"

  validation {
    condition     = contains(["WAF_v2", "Standard_v2"], var.sku_name)
    error_message = "sku_name must be one of: WAF_v2, Standard_v2."
  }
}

variable "autoscale_min_capacity" {
  description = "Minimum instance capacity used for autoscaling."
  type        = number
  default     = 2
}

variable "autoscale_max_capacity" {
  description = "Maximum instance capacity used for autoscaling."
  type        = number
  default     = 10
}

variable "subnet_id" {
  description = "ID of the subnet the gateway_ip_configuration is attached to. Must be dedicated to Application Gateway."
  type        = string
}

variable "create_public_ip" {
  description = "Whether this module creates the public IP used by the frontend IP configuration."
  type        = bool
  default     = true
}

variable "public_ip_id" {
  description = "ID of an existing public IP to use for the frontend IP configuration. Required when create_public_ip is false."
  type        = string
  default     = null
}

variable "public_ip_allocation_method" {
  description = "Allocation method of the public IP created by this module."
  type        = string
  default     = "Static"

  validation {
    condition     = contains(["Static", "Dynamic"], var.public_ip_allocation_method)
    error_message = "public_ip_allocation_method must be one of: Static, Dynamic."
  }
}

variable "public_ip_sku" {
  description = "SKU of the public IP created by this module."
  type        = string
  default     = "Standard"
}

variable "private_ip_address" {
  description = "Static private IP address added as an additional frontend IP configuration. Omit for public-only listeners."
  type        = string
  default     = null
}

variable "backend_address_pools" {
  description = "Map of backend address pools, keyed by a unique pool name."
  type = map(object({
    ip_addresses = optional(list(string))
    fqdns        = optional(list(string))
  }))
}

variable "probes" {
  description = "Map of custom health probes, keyed by a unique probe name."
  type = map(object({
    protocol            = optional(string, "Http")
    path                = string
    host                = optional(string, "127.0.0.1")
    interval            = optional(number, 30)
    timeout             = optional(number, 30)
    unhealthy_threshold = optional(number, 3)
  }))
  default = {}
}

variable "backend_http_settings" {
  description = "Map of backend HTTP settings, keyed by a unique settings name."
  type = map(object({
    port                  = number
    protocol              = optional(string, "Https")
    cookie_based_affinity = optional(string, "Disabled")
    request_timeout       = optional(number, 30)
    path                  = optional(string)
    host_name             = optional(string)
    probe_key             = optional(string)
  }))
}

variable "http_listeners" {
  description = "Map of HTTP listeners, keyed by a unique listener name."
  type = map(object({
    frontend_port        = number
    protocol             = optional(string, "Https")
    host_name            = optional(string)
    require_sni          = optional(bool, false)
    use_private_frontend = optional(bool, false)
    key_vault_secret_id  = optional(string)
  }))
}

variable "request_routing_rules" {
  description = "Map of request routing rules, keyed by a unique rule name."
  type = map(object({
    priority                   = number
    rule_type                  = optional(string, "Basic")
    http_listener_key          = string
    backend_address_pool_key   = optional(string)
    backend_http_settings_key  = optional(string)
    redirect_configuration_key = optional(string)
  }))
}

variable "redirect_configurations" {
  description = "Map of redirect configurations, keyed by a unique redirect name and referenced from request_routing_rules."
  type = map(object({
    redirect_type        = string
    target_listener_key  = optional(string)
    target_url           = optional(string)
    include_path         = optional(bool, true)
    include_query_string = optional(bool, true)
  }))
  default = {}
}

variable "identity_ids" {
  description = "IDs of user-assigned managed identities attached to the gateway. Required when http_listeners reference key_vault_secret_id."
  type        = list(string)
  default     = []
}

variable "waf_configuration" {
  description = "Web Application Firewall configuration. Only applies when sku_name is WAF_v2."
  type = object({
    enabled          = optional(bool, true)
    firewall_mode    = optional(string, "Prevention")
    rule_set_version = optional(string, "3.2")
    disabled_rule_group = optional(list(object({
      rule_group_name = string
      rules           = optional(list(number))
    })), [])
  })
  default = null
}

variable "tags" {
  description = "Tags applied to every resource created by this module."
  type        = map(string)
  default     = {}
}
