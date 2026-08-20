variable "name" {
  description = "Name of the AKS cluster."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group the cluster is created in."
  type        = string
}

variable "location" {
  description = "Azure region the cluster is deployed to."
  type        = string
}

variable "dns_prefix" {
  description = "DNS prefix used when creating the managed cluster's FQDN."
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version to use. Uses the latest recommended version supported by AKS when null."
  type        = string
  default     = null
}

variable "default_node_pool" {
  description = "Configuration for the cluster's default (system) node pool."
  type = object({
    vm_size                      = string
    node_count                   = optional(number)
    enable_auto_scaling          = optional(bool, false)
    min_count                    = optional(number)
    max_count                    = optional(number)
    os_disk_size_gb              = optional(number)
    only_critical_addons_enabled = optional(bool, true)
    vnet_subnet_id               = optional(string)
    zones                        = optional(list(string), [])
  })
}

variable "identity_type" {
  description = "Type of managed identity assigned to the cluster, SystemAssigned or UserAssigned."
  type        = string
  default     = "SystemAssigned"

  validation {
    condition     = contains(["SystemAssigned", "UserAssigned"], var.identity_type)
    error_message = "identity_type must be either \"SystemAssigned\" or \"UserAssigned\"."
  }
}

variable "identity_ids" {
  description = "List of user assigned identity IDs. Required when identity_type is UserAssigned."
  type        = list(string)
  default     = []
}

variable "network_plugin" {
  description = "Network plugin used by the cluster, azure or kubenet."
  type        = string
  default     = "azure"

  validation {
    condition     = contains(["azure", "kubenet"], var.network_plugin)
    error_message = "network_plugin must be either \"azure\" or \"kubenet\"."
  }
}

variable "network_policy" {
  description = "Network policy used by the cluster, azure, calico or null to disable."
  type        = string
  default     = null
}

variable "service_cidr" {
  description = "CIDR used for the Kubernetes service address range. Must not overlap with any subnet ranges."
  type        = string
  default     = null
}

variable "dns_service_ip" {
  description = "IP address within service_cidr used for cluster DNS."
  type        = string
  default     = null
}

variable "outbound_type" {
  description = "Outbound routing method used by the cluster, userDefinedRouting or loadBalancer."
  type        = string
  default     = "userDefinedRouting"

  validation {
    condition     = contains(["userDefinedRouting", "loadBalancer"], var.outbound_type)
    error_message = "outbound_type must be either \"userDefinedRouting\" or \"loadBalancer\"."
  }
}

variable "private_cluster_enabled" {
  description = "Whether the cluster's API server is only accessible from within the virtual network."
  type        = bool
  default     = true
}

variable "azure_rbac_enabled" {
  description = "Whether Azure RBAC is used for Kubernetes authorization in addition to Azure AD authentication."
  type        = bool
  default     = true
}

variable "admin_group_object_ids" {
  description = "List of Azure AD group object IDs granted cluster admin access."
  type        = list(string)
  default     = []
}

variable "log_analytics_workspace_id" {
  description = "ID of the Log Analytics workspace the oms_agent add-on sends container insights to. Add-on is disabled when null."
  type        = string
  default     = null
}

variable "authorized_ip_ranges" {
  description = "List of CIDR ranges allowed to access the API server. Allows all when empty."
  type        = list(string)
  default     = []
}

variable "automatic_channel_upgrade" {
  description = "Automatic upgrade channel for the cluster, patch, rapid, node-image, stable or null to disable."
  type        = string
  default     = null

  validation {
    condition     = var.automatic_channel_upgrade == null || contains(["patch", "rapid", "node-image", "stable"], var.automatic_channel_upgrade)
    error_message = "automatic_channel_upgrade must be one of \"patch\", \"rapid\", \"node-image\", \"stable\" or null."
  }
}

variable "maintenance_window" {
  description = "Maintenance window allowed periods for cluster upgrades."
  type = object({
    allowed = list(object({
      day   = string
      hours = list(number)
    }))
  })
  default = null
}

variable "key_vault_secrets_provider_enabled" {
  description = "Whether the Azure Key Vault Secrets Provider add-on is enabled."
  type        = bool
  default     = true
}

variable "secret_rotation_enabled" {
  description = "Whether secret rotation is enabled for the Key Vault Secrets Provider add-on. Only used when key_vault_secrets_provider_enabled is true."
  type        = bool
  default     = true
}

variable "additional_node_pools" {
  description = "Map of additional node pools to create, keyed by a unique node pool name."
  type = map(object({
    vm_size             = string
    node_count          = optional(number)
    enable_auto_scaling = optional(bool, false)
    min_count           = optional(number)
    max_count           = optional(number)
    mode                = optional(string, "User")
    zones               = optional(list(string), [])
    vnet_subnet_id      = optional(string)
    node_taints         = optional(list(string), [])
    node_labels         = optional(map(string), {})
  }))
  default = {}
}

variable "tags" {
  description = "Tags applied to every resource created by this module."
  type        = map(string)
  default     = {}
}
