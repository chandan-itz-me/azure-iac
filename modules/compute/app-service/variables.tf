variable "name" {
  description = "Name of the web app."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group the web app is created in."
  type        = string
}

variable "location" {
  description = "Azure region the web app is deployed to."
  type        = string
}

variable "os_type" {
  description = "Operating system family of the web app, linux or windows."
  type        = string

  validation {
    condition     = contains(["linux", "windows"], var.os_type)
    error_message = "os_type must be either \"linux\" or \"windows\"."
  }
}

variable "create_service_plan" {
  description = "Whether an App Service Plan is created by this module. Set to false to attach to an existing plan via service_plan_id."
  type        = bool
  default     = true
}

variable "service_plan_id" {
  description = "ID of an existing App Service Plan. Required when create_service_plan is false."
  type        = string
  default     = null
}

variable "sku_name" {
  description = "SKU name of the App Service Plan created by this module, e.g. B1, P1v3. Only used when create_service_plan is true."
  type        = string
  default     = "P1v3"
}

variable "dotnet_version" {
  description = ".NET version for the application stack, e.g. \"8.0\". Only used when relevant to os_type."
  type        = string
  default     = null
}

variable "node_version" {
  description = "Node.js version for the application stack, e.g. \"20-lts\". Only used for linux web apps."
  type        = string
  default     = null
}

variable "python_version" {
  description = "Python version for the application stack, e.g. \"3.12\". Only used for linux web apps."
  type        = string
  default     = null
}

variable "java_version" {
  description = "Java version for the application stack, e.g. \"17\". Only used when relevant to os_type."
  type        = string
  default     = null
}

variable "php_version" {
  description = "PHP version for the application stack, e.g. \"8.3\". Only used for linux web apps."
  type        = string
  default     = null
}

variable "always_on" {
  description = "Whether the web app is kept loaded even when there is no incoming traffic."
  type        = bool
  default     = true
}

variable "http2_enabled" {
  description = "Whether HTTP/2 is enabled for the web app."
  type        = bool
  default     = true
}

variable "minimum_tls_version" {
  description = "Minimum TLS version accepted by the web app."
  type        = string
  default     = "1.2"

  validation {
    condition     = contains(["1.0", "1.1", "1.2", "1.3"], var.minimum_tls_version)
    error_message = "minimum_tls_version must be one of \"1.0\", \"1.1\", \"1.2\" or \"1.3\"."
  }
}

variable "app_settings" {
  description = "Map of application settings applied to the web app."
  type        = map(string)
  default     = {}
}

variable "connection_strings" {
  description = "Map of connection strings applied to the web app, keyed by a unique connection string name."
  type = map(object({
    type  = string
    value = string
  }))
  default   = {}
  sensitive = true
}

variable "identity_type" {
  description = "Type of managed identity assigned to the web app."
  type        = string
  default     = "SystemAssigned"

  validation {
    condition     = contains(["SystemAssigned", "UserAssigned", "SystemAssigned, UserAssigned", "None"], var.identity_type)
    error_message = "identity_type must be one of \"SystemAssigned\", \"UserAssigned\", \"SystemAssigned, UserAssigned\" or \"None\"."
  }
}

variable "identity_ids" {
  description = "List of user assigned identity IDs. Required when identity_type includes UserAssigned."
  type        = list(string)
  default     = []
}

variable "virtual_network_subnet_id" {
  description = "ID of the subnet used for VNet integration. VNet integration is disabled when null."
  type        = string
  default     = null
}

variable "https_only" {
  description = "Whether the web app only accepts HTTPS traffic."
  type        = bool
  default     = true
}

variable "custom_domain" {
  description = "Custom domain bound to the web app with an App Service managed certificate. Disabled when null."
  type = object({
    hostname = string
  })
  default = null
}

variable "sticky_settings" {
  description = "App settings and connection strings that stay attached to a slot instead of swapping with it."
  type = object({
    app_setting_names       = optional(list(string), [])
    connection_string_names = optional(list(string), [])
  })
  default = null
}

variable "deployment_slots" {
  description = "Map of deployment slots to create, keyed by a unique slot name."
  type = map(object({
    app_settings = optional(map(string), {})
  }))
  default = {}
}

variable "tags" {
  description = "Tags applied to every resource created by this module."
  type        = map(string)
  default     = {}
}
