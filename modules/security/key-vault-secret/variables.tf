variable "key_vault_id" {
  description = "ID of the Key Vault the secrets are created in."
  type        = string
}

variable "secrets" {
  description = "Map of secrets, keyed by a unique secret name. Set generate_value to true to have a random value generated instead of supplying value."
  type = map(object({
    value             = optional(string)
    content_type      = optional(string)
    expiration_date   = optional(string)
    not_before_date   = optional(string)
    generate_value    = optional(bool, false)
    generated_length  = optional(number, 32)
    generated_special = optional(bool, true)
  }))
  sensitive = true

  validation {
    condition = alltrue([
      for k, v in var.secrets :
      (v.generate_value && v.value == null) || (!v.generate_value && v.value != null)
    ])
    error_message = "Each secret must either set generate_value = true, or supply a non-null value, but not both."
  }
}

variable "tags" {
  description = "Tags applied to every secret created by this module."
  type        = map(string)
  default     = {}
}
