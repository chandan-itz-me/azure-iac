variable "resource_group_name" {
  description = "Name of the resource group the managed identities are created in."
  type        = string
}

variable "location" {
  description = "Azure region the managed identities are deployed to."
  type        = string
}

variable "identities" {
  description = "Map of user-assigned managed identities to create, keyed by a unique identity key."
  type = map(object({
    name = string
  }))
}

variable "federated_credentials" {
  description = "Map of federated identity credentials for workload identity federation (e.g. GitHub Actions OIDC), keyed by a unique credential name."
  type = map(object({
    identity_key = string
    issuer       = string
    subject      = string
    audiences    = optional(list(string), ["api://AzureADTokenExchange"])
  }))
  default = {}
}

variable "tags" {
  description = "Tags applied to every resource created by this module."
  type        = map(string)
  default     = {}
}
