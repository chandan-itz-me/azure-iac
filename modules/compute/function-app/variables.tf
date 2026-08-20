variable "name" {
  description = "Name of the function app."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group the function app is created in."
  type        = string
}

variable "location" {
  description = "Azure region the function app is deployed to."
  type        = string
}

variable "os_type" {
  description = "Operating system family of the function app, linux or windows."
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
  description = "SKU name of the App Service Plan created by this module, e.g. Y1, EP1, P1v3. Only used when create_service_plan is true."
  type        = string
  default     = "Y1"
}

variable "storage_account_name" {
  description = "Name of an existing storage account used for function app content and triggers."
  type        = string
}

variable "storage_account_access_key" {
  description = "Access key of the storage account used for function app content and triggers."
  type        = string
  sensitive   = true
}

variable "dotnet_version" {
  description = ".NET version for the application stack, e.g. \"8.0\". Only used when relevant to os_type."
  type        = string
  default     = null
}

variable "node_version" {
  description = "Node.js version for the application stack, e.g. \"20\". Only used when relevant to os_type."
  type        = string
  default     = null
}

variable "python_version" {
  description = "Python version for the application stack, e.g. \"3.12\". Only used for linux function apps."
  type        = string
  default     = null
}

variable "java_version" {
  description = "Java version for the application stack, e.g. \"17\". Only used when relevant to os_type."
  type        = string
  default     = null
}

variable "app_settings" {
  description = "Map of application settings applied to the function app."
  type        = map(string)
  default     = {}
}

variable "identity_type" {
  description = "Type of managed identity assigned to the function app."
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
  description = "Whether the function app only accepts HTTPS traffic."
  type        = bool
  default     = true
}

variable "function_app_slots" {
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
