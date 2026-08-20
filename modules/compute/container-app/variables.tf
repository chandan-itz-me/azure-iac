variable "name" {
  description = "Name of the container app."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group the container app is created in."
  type        = string
}

variable "location" {
  description = "Azure region the container app is deployed to."
  type        = string
}

variable "create_environment" {
  description = "Whether a Container Apps environment is created by this module. Set to false to attach to an existing environment via container_app_environment_id."
  type        = bool
  default     = true
}

variable "container_app_environment_id" {
  description = "ID of an existing Container Apps environment. Required when create_environment is false."
  type        = string
  default     = null
}

variable "log_analytics_workspace_id" {
  description = "ID of the Log Analytics workspace used by the Container Apps environment. Required when create_environment is true."
  type        = string
  default     = null
}

variable "internal_load_balancer_enabled" {
  description = "Whether the Container Apps environment is only accessible from within its virtual network. Only used when create_environment is true."
  type        = bool
  default     = false
}

variable "infrastructure_subnet_id" {
  description = "ID of the subnet the Container Apps environment integrates with for VNet integration. Only used when create_environment is true."
  type        = string
  default     = null
}

variable "revision_mode" {
  description = "Revision mode of the container app, Single or Multiple."
  type        = string
  default     = "Single"

  validation {
    condition     = contains(["Single", "Multiple"], var.revision_mode)
    error_message = "revision_mode must be either \"Single\" or \"Multiple\"."
  }
}

variable "containers" {
  description = "Map of containers to run in the container app, keyed by a unique container name."
  type = map(object({
    image      = string
    cpu        = number
    memory     = string
    env        = optional(map(string), {})
    secret_env = optional(map(string), {})
    liveness_probe = optional(object({
      transport = string
      port      = number
      path      = optional(string)
    }))
    readiness_probe = optional(object({
      transport = string
      port      = number
      path      = optional(string)
    }))
  }))
}

variable "ingress" {
  description = "Ingress configuration for the container app. Ingress is disabled when null."
  type = object({
    external_enabled = optional(bool, false)
    target_port      = number
    transport        = optional(string, "auto")
    traffic_weight = optional(list(object({
      latest_revision = optional(bool, true)
      percentage      = number
    })), [{ latest_revision = true, percentage = 100 }])
  })
  default = null
}

variable "identity_type" {
  description = "Type of managed identity assigned to the container app."
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

variable "secrets" {
  description = "Map of secret name to value, referenced by containers via secret_env."
  type        = map(string)
  default     = {}
  sensitive   = true
}

variable "dapr" {
  description = "Dapr configuration for the container app. Dapr is disabled when null."
  type = object({
    app_id       = string
    app_port     = number
    app_protocol = optional(string, "http")
  })
  default = null
}

variable "min_replicas" {
  description = "Minimum number of replicas the container app scales to."
  type        = number
  default     = 0
}

variable "max_replicas" {
  description = "Maximum number of replicas the container app scales to."
  type        = number
  default     = 10
}

variable "tags" {
  description = "Tags applied to every resource created by this module."
  type        = map(string)
  default     = {}
}
