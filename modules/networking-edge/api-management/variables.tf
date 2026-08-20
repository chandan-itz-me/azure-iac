variable "name" {
  description = "Name of the API Management instance."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group the API Management instance is created in."
  type        = string
}

variable "location" {
  description = "Azure region the API Management instance is deployed to."
  type        = string
}

variable "publisher_name" {
  description = "Name of the API publisher, shown to API consumers."
  type        = string
}

variable "publisher_email" {
  description = "Email address of the API publisher, used for notifications."
  type        = string
}

variable "sku_name" {
  description = "SKU of the API Management instance, in the format {tier}_{capacity}, e.g. Developer_1, Standard_1, Premium_2."
  type        = string
  default     = "Developer_1"

  validation {
    condition     = can(regex("^(Consumption|Developer|Basic|Standard|Premium)_[0-9]+$", var.sku_name))
    error_message = "sku_name must be in the format {tier}_{capacity}, e.g. Developer_1."
  }
}

variable "virtual_network_type" {
  description = "Type of virtual network integration for the API Management instance."
  type        = string
  default     = "None"

  validation {
    condition     = contains(["None", "External", "Internal"], var.virtual_network_type)
    error_message = "virtual_network_type must be one of: None, External, Internal."
  }
}

variable "subnet_id" {
  description = "ID of the subnet used for virtual network integration. Required when virtual_network_type is External or Internal."
  type        = string
  default     = null
}

variable "identity_type" {
  description = "Type of managed identity assigned to the API Management instance."
  type        = string
  default     = "SystemAssigned"

  validation {
    condition     = contains(["SystemAssigned", "UserAssigned", "SystemAssigned, UserAssigned"], var.identity_type)
    error_message = "identity_type must be one of: SystemAssigned, UserAssigned, \"SystemAssigned, UserAssigned\"."
  }
}

variable "identity_ids" {
  description = "IDs of user-assigned managed identities attached to the API Management instance. Required when identity_type includes UserAssigned."
  type        = list(string)
  default     = []
}

variable "min_api_version" {
  description = "Limits the API Management control plane API calls to a minimum API version. Set to null to allow all versions."
  type        = string
  default     = null
}

variable "security_protocols" {
  description = "Legacy TLS/SSL protocol and cipher toggles. All disabled by default to enforce TLS 1.2+."
  type = object({
    enable_backend_ssl30      = optional(bool, false)
    enable_backend_tls10      = optional(bool, false)
    enable_backend_tls11      = optional(bool, false)
    enable_frontend_ssl30     = optional(bool, false)
    enable_frontend_tls10     = optional(bool, false)
    enable_frontend_tls11     = optional(bool, false)
    enable_triple_des_ciphers = optional(bool, false)
  })
  default = {}
}

variable "custom_domain_gateway" {
  description = "Custom domain configuration for the API Management gateway endpoint. Set to null to use the default *.azure-api.net hostname."
  type = object({
    host_name                    = string
    key_vault_secret_id          = string
    negotiate_client_certificate = optional(bool, false)
  })
  default = null
}

variable "apis" {
  description = "Map of APIs to publish, keyed by a unique API name."
  type = map(object({
    display_name = string
    path         = string
    revision     = optional(string, "1")
    protocols    = optional(list(string), ["https"])
    service_url  = optional(string)
    import = optional(object({
      content_format = string
      content_value  = string
    }))
  }))
  default = {}
}

variable "products" {
  description = "Map of products, keyed by a unique product name. api_keys references keys from var.apis to associate."
  type = map(object({
    display_name          = string
    description           = optional(string)
    subscription_required = optional(bool, true)
    approval_required     = optional(bool, false)
    published             = optional(bool, true)
    api_keys              = optional(list(string), [])
  }))
  default = {}
}

variable "named_values" {
  description = "Map of named values (API Management properties), keyed by a unique name. Entries with secret = true are marked sensitive."
  type = map(object({
    display_name = string
    value        = string
    secret       = optional(bool, false)
  }))
  default   = {}
  sensitive = true
}

variable "backends" {
  description = "Map of backends, keyed by a unique backend name."
  type = map(object({
    protocol    = string
    url         = string
    description = optional(string)
    resource_id = optional(string)
  }))
  default = {}
}

variable "tags" {
  description = "Tags applied to every resource created by this module."
  type        = map(string)
  default     = {}
}
