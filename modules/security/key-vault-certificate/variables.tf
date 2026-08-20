variable "key_vault_id" {
  description = "ID of the Key Vault the certificates are created in."
  type        = string
}

variable "certificates" {
  description = "Map of certificates, keyed by a unique certificate name. Set import to bring an existing certificate, or leave it null to have Key Vault generate one from certificate_policy. certificate_policy is always required by the underlying API, even for imports (use issuer_name = \"Unknown\" in that case)."
  type = map(object({
    import = optional(object({
      contents = string
      password = optional(string)
    }))
    certificate_policy = object({
      issuer_name  = optional(string, "Self")
      exportable   = optional(bool, true)
      key_type     = optional(string, "RSA")
      key_size     = optional(number, 2048)
      curve        = optional(string)
      reuse_key    = optional(bool, true)
      content_type = optional(string, "application/x-pkcs12")

      subject            = string
      validity_in_months = optional(number, 12)
      key_usage          = optional(list(string), ["digitalSignature", "keyEncipherment"])
      extended_key_usage = optional(list(string), [])
      subject_alternative_names = optional(object({
        dns_names = optional(list(string), [])
        emails    = optional(list(string), [])
        upns      = optional(list(string), [])
      }))

      lifetime_action = optional(object({
        action_type         = optional(string, "AutoRenew")
        lifetime_percentage = optional(number)
        days_before_expiry  = optional(number)
      }), {})
    })
  }))
}

variable "tags" {
  description = "Tags applied to every certificate created by this module."
  type        = map(string)
  default     = {}
}
