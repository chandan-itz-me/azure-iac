locals {
  common_tags = merge(
    {
      Environment = var.environment
      Project     = var.project_name
      ManagedBy   = "terraform"
    },
    var.common_tags,
  )

  # Identity references use "module-key.identity-key" so workloads can attach
  # identities created by any managed-identity module instance.
  managed_identity_ids = merge([
    for module_key, identity_module in module.managed_identities : {
      for identity_key, identity_id in identity_module.identity_ids :
      "${module_key}.${identity_key}" => identity_id
    }
  ]...)
}
