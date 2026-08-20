# -----------------------------------------------------------------------------
# Global settings
# -----------------------------------------------------------------------------

variable "subscription_id" {
  description = "Azure subscription ID. Leave null to use the subscription from the CLI/environment context."
  type        = string
  default     = null
}

variable "tenant_id" {
  description = "Azure Active Directory tenant ID. Leave null to use the tenant from the CLI/environment context."
  type        = string
  default     = null
}

variable "location" {
  description = "Azure region where the root composition is deployed."
  type        = string
}

variable "project_name" {
  description = "Project name used as the resource naming prefix."
  type        = string
}

variable "environment" {
  description = "Deployment environment, such as dev, test, or prod."
  type        = string
}

variable "common_tags" {
  description = "Tags applied to every resource created by this root composition."
  type        = map(string)
  default     = {}
}

# -----------------------------------------------------------------------------
# Resource group
# -----------------------------------------------------------------------------

variable "resource_group_name" {
  description = "Name of the resource group. Defaults to <project_name>-<environment> when null."
  type        = string
  default     = null
}

# -----------------------------------------------------------------------------
# Networking
# -----------------------------------------------------------------------------

variable "vnet_address_space" {
  description = "Address space for the core virtual network."
  type        = list(string)
}

variable "subnets" {
  description = "Subnet definitions keyed by stable subnet name, passed to the subnet module."
  type = map(object({
    address_prefixes = list(string)
  }))
  default = {}
}

variable "nat_gateway_subnet_keys" {
  description = "Subnet keys (from var.subnets) that the core NAT gateway is associated with."
  type        = list(string)
  default     = []
}

# -----------------------------------------------------------------------------
# Object storage
# -----------------------------------------------------------------------------

variable "storage_account_name" {
  description = "Globally unique storage account name for application artifacts."
  type        = string
}

# -----------------------------------------------------------------------------
# Key Vault
# -----------------------------------------------------------------------------

variable "key_vault_name" {
  description = "Name of the core Key Vault."
  type        = string
}

# -----------------------------------------------------------------------------
# Function App
# -----------------------------------------------------------------------------

variable "function_app_name" {
  description = "Name of the core Function App."
  type        = string
}

variable "function_app_os_type" {
  description = "OS type of the Function App. Valid values: Linux, Windows."
  type        = string
  default     = "Linux"
}

variable "function_app_service_plan_sku" {
  description = "SKU of the App Service Plan backing the Function App."
  type        = string
  default     = "Y1"
}

# -----------------------------------------------------------------------------
# Log Analytics
# -----------------------------------------------------------------------------

variable "log_analytics_workspace_name" {
  description = "Name of the core Log Analytics workspace."
  type        = string
}

# -----------------------------------------------------------------------------
# Optional compute module configurations
# -----------------------------------------------------------------------------

variable "virtual_machines" {
  description = "Virtual machine configurations keyed by logical name. Values are passed to the virtual-machine module."
  type        = map(any)
  default     = {}
}

variable "vmss" {
  description = "Virtual Machine Scale Set configurations keyed by logical name. Values are passed to the vmss module."
  type        = map(any)
  default     = {}
}

variable "aks_clusters" {
  description = "AKS cluster configurations keyed by logical name. Values are passed to the aks-cluster module."
  type        = map(any)
  default     = {}
}

variable "container_apps" {
  description = "Container App configurations keyed by logical name. Values are passed to the container-app module."
  type        = map(any)
  default     = {}
}

variable "app_services" {
  description = "App Service configurations keyed by logical name. Values are passed to the app-service module."
  type        = map(any)
  default     = {}
}

# -----------------------------------------------------------------------------
# Optional database module configurations
# -----------------------------------------------------------------------------

variable "cosmos_dbs" {
  description = "Cosmos DB account configurations keyed by logical name. Values are passed to the cosmos-db module."
  type        = map(any)
  default     = {}
}

variable "sql_databases" {
  description = "Azure SQL Server/Database configurations keyed by logical name. Values are passed to the azure-sql-database module."
  type        = map(any)
  default     = {}
}

variable "redis_caches" {
  description = "Redis Cache configurations keyed by logical name. Values are passed to the redis-cache module."
  type        = map(any)
  default     = {}
}

# -----------------------------------------------------------------------------
# Optional messaging module configurations
# -----------------------------------------------------------------------------

variable "service_bus_namespaces" {
  description = "Service Bus namespace configurations keyed by logical name. Values are passed to the service-bus module."
  type        = map(any)
  default     = {}
}

variable "event_grids" {
  description = "Event Grid topic/domain configurations keyed by logical name. Values are passed to the event-grid module."
  type        = map(any)
  default     = {}
}

variable "event_hubs" {
  description = "Event Hub namespace configurations keyed by logical name. Values are passed to the event-hub module."
  type        = map(any)
  default     = {}
}

# -----------------------------------------------------------------------------
# Optional networking module configurations
# -----------------------------------------------------------------------------

variable "network_security_groups" {
  description = "NSG configurations keyed by logical name. Values are passed to the network-security-group module."
  type        = map(any)
  default     = {}
}

variable "private_dns_zones" {
  description = "Private DNS zone configurations keyed by logical name. Values are passed to the private-dns-zone module."
  type        = map(any)
  default     = {}
}

variable "vnet_peerings" {
  description = "VNet peering configurations keyed by logical name. Values are passed to the vnet-peering module."
  type        = map(any)
  default     = {}
}

variable "private_endpoints" {
  description = "Private endpoint configurations keyed by logical name. Values are passed to the private-endpoint module."
  type        = map(any)
  default     = {}
}

variable "vnet_gateways" {
  description = "VPN/ExpressRoute gateway configurations keyed by logical name. Values are passed to the vnet-gateway module."
  type        = map(any)
  default     = {}
}

# -----------------------------------------------------------------------------
# Optional edge module configurations
# -----------------------------------------------------------------------------

variable "application_gateways" {
  description = "Application Gateway configurations keyed by logical name. Values are passed to the application-gateway module."
  type        = map(any)
  default     = {}
}

variable "front_doors" {
  description = "Front Door profile configurations keyed by logical name. Values are passed to the front-door module."
  type        = map(any)
  default     = {}
}

variable "api_managements" {
  description = "API Management configurations keyed by logical name. Values are passed to the api-management module."
  type        = map(any)
  default     = {}
}

# -----------------------------------------------------------------------------
# Optional security module configurations
# -----------------------------------------------------------------------------

variable "key_vault_certificates" {
  description = "Key Vault certificate configurations keyed by logical name. Values are passed to the key-vault-certificate module."
  type        = map(any)
  default     = {}
}

variable "key_vault_secrets" {
  description = "Key Vault secret configurations keyed by logical name. Values are passed to the key-vault-secret module."
  type        = map(any)
  default     = {}
  sensitive   = true
}

variable "role_assignments" {
  description = "Role assignment configurations keyed by logical name. Values are passed to the role-assignment module."
  type        = map(any)
  default     = {}
}

variable "managed_identities" {
  description = "Additional managed identity configurations keyed by logical name. Values are passed to the managed-identity module."
  type        = map(any)
  default     = {}
}

# -----------------------------------------------------------------------------
# Optional observability, storage, and state backend configurations
# -----------------------------------------------------------------------------

variable "monitor_diagnostic_settings" {
  description = "Diagnostic settings configurations keyed by logical name. Values are passed to the monitor-diagnostic-settings module."
  type        = map(any)
  default     = {}
}

variable "monitor_alerts" {
  description = "Monitor alert configurations keyed by logical name. Values are passed to the monitor-alerts module."
  type        = map(any)
  default     = {}
}

variable "managed_disks" {
  description = "Managed disk configurations keyed by logical name. Values are passed to the managed-disk module."
  type        = map(any)
  default     = {}
}

variable "state_backends" {
  description = "Remote state bootstrap configurations keyed by logical name. Values are passed to the state-backend module."
  type        = map(any)
  default     = {}
}
